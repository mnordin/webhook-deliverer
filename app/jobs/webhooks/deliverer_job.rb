module Webhooks
  class DelivererJob < ApplicationJob
    class UnsuccessfulDelivery < StandardError; end

    retry_on UnsuccessfulDelivery, wait: :polynomially_longer, attempts: 10
    queue_as :webhook_deliveries

    def perform(webhook_delivery)
      response = Webhooks::Deliverer.call(webhook_delivery:)

      attempt = webhook_delivery.webhook_delivery_attempts.create!(
        response_code: response.status,
        response: response.body
      )

      if attempt.failure?
        raise UnsuccessfulDelivery.new("Unsuccessful delivery for WebhookDeliveryAttempt##{attempt.id}")
      end
    end
  end
end
