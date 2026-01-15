require "test_helper"

module Webhooks
  class CreateWebhookDeliveryTest < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test "it creates a webhook delivery" do
      webhook = create(:webhook, url: "https://example.com")
      webhook_subscription = create(:webhook_subscription, relative_path: "/test", webhook:)

      assert_difference "WebhookDelivery.count", 1 do
        Webhooks::CreateWebhookDelivery.call(
          webhook_subscription:,
          payload: {foo: "bar"}
        )
      end

      delivery = WebhookDelivery.last
      assert_equal delivery.status, "pending"
      assert_equal delivery.url, "https://example.com/test"
      assert_equal delivery.payload, {foo: "bar"}.to_json
      assert_equal delivery.webhook_subscription, webhook_subscription
    end

    test "enqueues a webhook delivery job" do
      webhook = create(:webhook, url: "https://example.com")
      webhook_subscription = create(:webhook_subscription, relative_path: "/test", webhook:)

      assert_enqueued_jobs 1, only: DelivererJob do
        Webhooks::CreateWebhookDelivery.call(
          webhook_subscription:,
          payload: {foo: "bar"}
        )
      end
    end
  end
end
