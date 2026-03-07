module Webhooks
  class DelivererJob < ApplicationJob
    class UnsuccessfulDelivery < StandardError; end

    retry_on UnsuccessfulDelivery, wait: :polynomially_longer, attempts: 10
    queue_as :webhook_deliveries

    def perform(webhook_delivery)
      response = Webhooks::Deliverer.call(webhook_delivery:)

      # Create the attempt record
      webhook_delivery.webhook_delivery_attempts.create!(
        status: response.success? ? "success" : "failure",
        response_code: response.status,
        response: response.body
      )

      # Re-enqueue the job for all delivery failures
      return unless response.failure?

      raise UnsuccessfulDelivery.new("Unsuccesful delivery for WebhookDelivery##{webhook_delivery.id}")
    end
  end
end
