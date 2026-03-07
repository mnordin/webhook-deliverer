class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_subscription
  has_many :webhook_delivery_attempts

  enum :status, {pending: 0, success: 1, failure: 2}

  def status
    last_attempt&.status || "pending"
  end
end
