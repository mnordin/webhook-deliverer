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
    broadcast_prepend_later_to(webhook_delivery.identity)
    broadcast_update_later_to(
      webhook_delivery.identity,
      target: ActionView::RecordIdentifier.dom_id(webhook_delivery, :attributes),
      partial: "webhook_deliveries/attributes",
      locals: {webhook_delivery:}
    )
  end
end
