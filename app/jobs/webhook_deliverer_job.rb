class WebhookDelivererJob < ApplicationJob
  class UnsuccessfulDelivery < StandardError; end
  queue_as :default

  def perform(webhook_delivery_id)
    webhook_delivery = WebhookDelivery.find(webhook_delivery_id)

    webhook_delivery.increment!(:attempts)
    response = Webhooks::Deliverer.call(webhook_delivery:)

    case response.status
    when 200..299
      webhook_delivery.update(
        status: "success",
        last_response_code: response.status,
        last_response: response.body,
      )
    else
      webhook_delivery.update(
        status: "failure",
        last_response_code: response.status,
        last_response: response.body,
      )

      # Re-enqueue the job for all delivery failures
      raise UnsuccessfulDelivery.new("Unsuccesful delivery for WebhookDelivery##{webhook_delivery.id}")
    end
  end
end
