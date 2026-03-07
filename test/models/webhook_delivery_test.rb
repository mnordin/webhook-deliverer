require "test_helper"

class WebhookDeliveryTest < ActiveSupport::TestCase
  test "is valid when url is set" do
    webhook_delivery = build(:webhook_delivery, url: nil)

    assert_not webhook_delivery.valid?
    assert_includes webhook_delivery.errors[:url], "can't be blank"
  end

  test "#last_response_code returns the response code from the last attempt" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:, response_code: 200)

    assert_equal 200, webhook_delivery.last_response_code
  end

  test "#last_response_code returns nil when there are no attempts" do
    webhook_delivery = create(:webhook_delivery)

    assert_nil webhook_delivery.last_response_code
  end

  test "#last_response returns the response from the last attempt" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:, response: "Success")

    assert_equal "Success", webhook_delivery.last_response
  end

  test "#last_response returns nil when there are no attempts" do
    webhook_delivery = create(:webhook_delivery)

    assert_nil webhook_delivery.last_response
  end

  test "#attempts returns the count of delivery attempts" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:)
    create(:webhook_delivery_attempt, webhook_delivery:)

    assert_equal 2, webhook_delivery.attempts
  end

  test "#success? returns true when the last attempt is successful" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:)

    assert webhook_delivery.success?
  end

  test "#success? returns false when the last attempt is a failure" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, :failure, webhook_delivery:)

    assert_not webhook_delivery.success?
  end

  test "#success? returns true for a delivery that failed then succeeded" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, :failure, webhook_delivery:)
    create(:webhook_delivery_attempt, webhook_delivery:)

    assert webhook_delivery.success?
  end

  test "#failure? returns true when the last attempt is a failure" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, :failure, webhook_delivery:)

    assert webhook_delivery.failure?
  end

  test "#failure? returns false when the last attempt is successful" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:)

    assert_not webhook_delivery.failure?
  end

  test "#failure? returns false for a delivery that failed then succeeded" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, :failure, webhook_delivery:)
    create(:webhook_delivery_attempt, webhook_delivery:)

    assert_not webhook_delivery.failure?
  end
end
