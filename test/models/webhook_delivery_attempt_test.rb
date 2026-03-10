require "test_helper"

class WebhookDeliveryAttemptTest < ActiveSupport::TestCase
  test "is considered successful when assigned successful response codes" do
    [200, 201, 299].each do |response_code|
      webhook_delivery_attempt = build(:webhook_delivery_attempt, response_code:)

      assert webhook_delivery_attempt.success?
      refute webhook_delivery_attempt.failure?
    end
  end

  test "is considered failure when assigned unsuccessful response codes" do
    [400, 404, 500].each do |response_code|
      webhook_delivery_attempt = build(:webhook_delivery_attempt, response_code:)

      assert webhook_delivery_attempt.failure?
      refute webhook_delivery_attempt.success?
    end
  end

  test "is valid when response_code is set" do
    webhook_delivery_attempt = build(:webhook_delivery_attempt, response_code: nil)

    assert_not webhook_delivery_attempt.valid?
    assert_includes webhook_delivery_attempt.errors[:response_code], "can't be blank"
  end
end
