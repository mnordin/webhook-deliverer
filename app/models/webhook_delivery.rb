class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_subscription
  has_many :webhook_delivery_attempts, dependent: :destroy

  validates :url, presence: true

  scope :with_latest_attempt_summary, -> {
    joins(<<~SQL)
      LEFT JOIN (
        SELECT
          webhook_delivery_id,
          MAX(id) AS latest_attempt_id,
          COUNT(*) AS attempts_count
        FROM webhook_delivery_attempts
        GROUP BY webhook_delivery_id
      ) AS attempts_summary
      ON attempts_summary.webhook_delivery_id = webhook_deliveries.id
      LEFT JOIN webhook_delivery_attempts AS latest_attempt
        ON latest_attempt.id = attempts_summary.latest_attempt_id
    SQL
      .select(<<~SQL)
        webhook_deliveries.*,
        attempts_summary.attempts_count,
        latest_attempt.response_code AS last_response_code,
        latest_attempt.response AS last_response
      SQL
  }

  def last_response_code
    self[:last_response_code] || last_attempt&.response_code
  end

  def last_response
    self[:last_response] || last_attempt&.response
  end

  def attempts_count
    self[:attempts_count] || webhook_delivery_attempts.count
  end

  def identity
    ActionView::RecordIdentifier.dom_id(self)
  end

  private

  def last_attempt
    @last_attempt ||= webhook_delivery_attempts.order(id: :desc).first
  end
end
