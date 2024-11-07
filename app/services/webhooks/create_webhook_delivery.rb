module Webhooks
  class CreateWebhookDelivery
    def self.call(**args)
      new(**args).call
    end

    def initialize(webhook_subscription:, payload:)
      @webhook_subscription = webhook_subscription
      @payload = payload
    end

    def call
      webhook_delivery = WebhookDelivery.create!(
        webhook_subscription:,
        url:,
        payload: payload.to_json,
      )

      DelivererJob.perform_later(webhook_delivery)
    end

    private

    attr_reader :webhook_subscription, :payload

    def url
      File.join(webhook_subscription.webhook.url, webhook_subscription.relative_path.to_s)
    end
  end
end
