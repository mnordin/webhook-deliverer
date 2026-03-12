class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_subscription
  has_many :webhook_delivery_attempts, dependent: :destroy

  validates :url, presence: true

  def self.latest_attempt_join
    <<~SQL.squish
      LEFT JOIN webhook_delivery_attempts AS latest_attempt
        ON latest_attempt.id = (
          SELECT id FROM webhook_delivery_attempts
          WHERE webhook_delivery_id = webhook_deliveries.id
          ORDER BY id DESC LIMIT 1
        )
    SQL
  end

  scope :with_latest_attempt_summary, lambda {
    attempts_count = <<~SQL.squish
      (SELECT COUNT(*)
       FROM webhook_delivery_attempts
       WHERE webhook_delivery_id = webhook_deliveries.id) AS attempts_count
    SQL

    joins(latest_attempt_join)
      .select(
        "webhook_deliveries.*",
        attempts_count,
        "latest_attempt.response_code AS last_response_code",
        "latest_attempt.response as last_response"
      )
  }

  def last_response_code
    self[:last_response_code] || last_attempt&.response_code
  end

  def last_response
    self[:last_response] || last_attempt&.response
  end

  def attempts
    self[:attempts_count] || webhook_delivery_attempts.count
  end

  def identity
    "webhook_delivery_#{id}"
  end

  private

  def last_attempt
    @last_attempt ||= webhook_delivery_attempts.order(id: :desc).first
  end
end
