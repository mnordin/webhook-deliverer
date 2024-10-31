module Webhooks
  class ProfileCreatedWebhookDeliveryJob < ApplicationJob
    queue_as :default

    def perform(user, webhook_subscription)
      payload = ProfileCreatedSerializer.new(user)

      CreateWebhookDelivery.call(webhook_subscription:, payload:)
    end
  end
end
