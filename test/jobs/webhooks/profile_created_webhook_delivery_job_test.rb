require "test_helper"

module Webhooks
  class ProfileCreatedWebhookDeliveryJobTest < ActiveJob::TestCase
    test "calls the CreateWebhookDelivery service with a serialized create event" do
      user = create(:user)
      subscription = create(:webhook_subscription, event: "profile_created")

      delivery_service = Minitest::Mock.new
      delivery_service.expect :call, true do |webhook_subscription:, payload:|
        assert_equal webhook_subscription, subscription
        assert_equal payload.to_json, ProfileCreatedSerializer.new(user).to_json
      end

      CreateWebhookDelivery.stub :call, delivery_service do
        ProfileCreatedWebhookDeliveryJob.new.perform(user, subscription)
      end

      delivery_service.verify
    end
  end
end
