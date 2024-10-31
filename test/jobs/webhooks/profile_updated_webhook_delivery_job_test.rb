require "test_helper"

module Webhooks
  class ProfileUpdatedWebhookDeliveryJobTest < ActiveJob::TestCase
    test "calls the CreateWebhookDelivery service with a serialized updated event" do
      user = create(:user)
      subscription = create(:webhook_subscription, event: "profile_updated")

      delivery_service = Minitest::Mock.new
      delivery_service.expect :call, true do |webhook_subscription:, payload:|
        assert_equal webhook_subscription, subscription
        assert_equal payload.to_json, ProfileUpdatedSerializer.new(user).to_json
      end

      CreateWebhookDelivery.stub :call, delivery_service do
        ProfileUpdatedWebhookDeliveryJob.new.perform(user, subscription)
      end

      delivery_service.verify
    end
  end
end
