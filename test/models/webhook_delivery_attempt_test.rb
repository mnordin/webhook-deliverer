require "test_helper"

class WebhookDeliveryAttemptTest < ActiveSupport::TestCase
  test "#status is success when response code are normal success codes" do
    (200..201).each do |response_code|
      webhook_delivery_attempt = build(:webhook_delivery_attempt, response_code:)

      assert "success", webhook_delivery_attempt.status
    end
  end

  test "#status is failures when response code are normal failure codes" do
    [400, 404, 500].each do |response_code|
      webhook_delivery_attempt = build(:webhook_delivery_attempt, response_code:)

      assert "failure", webhook_delivery_attempt.status
    end
  end

  test "is valid when response_code is set" do
    webhook_delivery_attempt = build(:webhook_delivery_attempt, response_code: nil)

    assert_not webhook_delivery_attempt.valid?
    assert_includes webhook_delivery_attempt.errors[:response_code], "can't be blank"
  end
end
