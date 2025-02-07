module Webhooks
  class DelivererJob < ApplicationJob
    class UnsuccessfulDelivery < StandardError; end

    retry_on UnsuccessfulDelivery, wait: :polynomially_longer, attempts: 10
    queue_as :webhook_deliveries

    def perform(webhook_delivery)
      webhook_delivery.increment!(:attempts)
      response = Webhooks::Deliverer.call(webhook_delivery:)

      if response.success?
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
end
