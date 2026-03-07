class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_subscription
  has_many :webhook_delivery_attempts, dependent: :destroy

  validates :url, presence: true

  def last_response_code
    last_attempt&.response_code
  end

  def last_response
    last_attempt&.response
  end

  def attempts
    webhook_delivery_attempts.count
  end

  def status
    last_attempt&.status || "pending"
  end

  delegate :success?, to: :last_attempt, allow_nil: true
  delegate :failure?, to: :last_attempt, allow_nil: true

  private

  def last_attempt
    @last_attempt ||= webhook_delivery_attempts.last
  end
end
