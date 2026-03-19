require "test_helper"

class WebhookSubscriptionTest < ActiveSupport::TestCase
  test "is valid when event is set" do
    webhook_subscription = build(:webhook_subscription, event: "profile_created")

    assert webhook_subscription.valid?
  end

  test "is invalid when event is not set" do
    webhook_subscription = build(:webhook_subscription, event: nil)

    refute webhook_subscription.valid?
    assert_includes webhook_subscription.errors[:event], "can't be blank"
  end
end
