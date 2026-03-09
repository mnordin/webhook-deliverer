require "test_helper"

module Webhooks
  class DelivererJobTest < ActiveJob::TestCase
    Response = Data.define(:status, :body)

    test "creates a successful attempt record for successful deliveries" do
      delivery = create(:webhook_delivery)
      successful_response = Webhooks::Response.new(
        Response.new(status: 200, body: {test: "success"}.to_json)
      )

      Webhooks::Deliverer.stub(:call, successful_response) do
        DelivererJob.new.perform(delivery)

        delivery.reload
        assert_equal 1, delivery.webhook_delivery_attempts.count
        attempt = delivery.webhook_delivery_attempts.last
        assert attempt.success?
        assert_equal 200, attempt.response_code
        assert_equal({test: "success"}.to_json, attempt.response)
      end
    end

    test "creates a successful attempt record for a previously failed attempt that is now successful" do
      delivery = create(:webhook_delivery, :failed)
      successful_response = Webhooks::Response.new(
        Response.new(status: 201, body: {status: "created"}.to_json)
      )

      Webhooks::Deliverer.stub(:call, successful_response) do
        DelivererJob.new.perform(delivery)
      end

      delivery.reload
      assert_equal 2, delivery.webhook_delivery_attempts.count
      attempt = delivery.webhook_delivery_attempts.last
      assert attempt.success?
      assert_equal 201, attempt.response_code
      assert_equal({status: "created"}.to_json, attempt.response)
    end

    test "creates a failure attempt record and raises an exception for unsuccessful deliveries" do
      delivery = create(:webhook_delivery)
      unsuccessful_response = Webhooks::Response.new(
        Response.new(status: 400, body: {test: "failures"}.to_json)
      )

      exception = assert_raises DelivererJob::UnsuccessfulDelivery do
        Webhooks::Deliverer.stub(:call, unsuccessful_response) do
          DelivererJob.new.perform(delivery)
        end
      end

      delivery.reload
      assert_equal 1, delivery.webhook_delivery_attempts.count
      attempt = delivery.webhook_delivery_attempts.last
      assert_equal(
        "Unsuccessful delivery for WebhookDeliveryAttempt##{attempt.id}",
        exception.message
      )
      assert attempt.failure?
      assert_equal 400, attempt.response_code
      assert_equal({test: "failures"}.to_json, attempt.response)
    end
  end
end
