class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_subscription
  has_many :webhook_delivery_attempts, dependent: :destroy

  has_one :last_delivery_attempt, -> {
    order(created_at: :desc)
  }, class_name: "WebhookDeliveryAttempt"

  validates :url, presence: true

  def identity
    ActionView::RecordIdentifier.dom_id(self)
  end
end
