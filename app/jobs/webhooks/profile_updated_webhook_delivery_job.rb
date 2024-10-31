module Webhooks
  class ProfileUpdatedWebhookDeliveryJob < ApplicationJob
    queue_as :default

    def perform(user, webhook_subscription)
      payload = ProfileUpdatedSerializer.new(user)

      CreateWebhookDelivery.call(webhook_subscription:, payload:)
    end
  end
end
