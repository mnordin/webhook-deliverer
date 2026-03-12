class WebhookDeliveryAttempt < ApplicationRecord
  belongs_to :webhook_delivery

  validates :response_code, presence: true

  after_commit :broadcast_later, on: :create

  def failure?
    !success?
  end

  def success?
    response_code.between?(200, 299)
  end

  private

  def broadcast_later
    broadcast_prepend_to(webhook_delivery.identity)
  end
end
