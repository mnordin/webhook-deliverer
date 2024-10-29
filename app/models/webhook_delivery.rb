class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_subscription

  enum :status, { pending: 0, success: 1, failure: 2 }

  validates :status, :url, presence: true
end
