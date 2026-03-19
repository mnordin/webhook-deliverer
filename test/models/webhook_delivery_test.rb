require "test_helper"

class WebhookDeliveryTest < ActiveSupport::TestCase
  test ".with_latest_attempt_summary caches last response and attempts" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:, response_code: 404)
    create(
      :webhook_delivery_attempt,
      webhook_delivery:,
      response_code: 201,
      response: {created: true}.to_json
    )

    delivery = WebhookDelivery.with_latest_attempt_summary.first

    assert_no_queries do
      assert_equal 201, delivery.last_response_code
      assert_equal 2, delivery.attempts_count
      assert_equal({created: true}.to_json, delivery.last_response)
    end
  end

  test ".with_latest_attempt_summary works on deliveries without any attempts" do
    delivery = create(:webhook_delivery)

    deliveries = WebhookDelivery.with_latest_attempt_summary

    assert_equal deliveries, [delivery]
    delivery = deliveries.first
    assert_equal delivery.attempts_count, 0
    assert_nil delivery.last_response_code
    assert_nil delivery.last_response
  end

  test "is valid when url is set" do
    webhook_delivery = build(:webhook_delivery, url: nil)

    assert_not webhook_delivery.valid?
    assert_includes webhook_delivery.errors[:url], "can't be blank"
  end

  test "#last_response_code returns the response code from the last attempt" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:, response_code: 500)
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

  test "#attempts_count returns the count of delivery attempts" do
    webhook_delivery = create(:webhook_delivery)
    create(:webhook_delivery_attempt, webhook_delivery:)
    create(:webhook_delivery_attempt, webhook_delivery:)

    assert_equal 2, webhook_delivery.attempts_count
  end
end
