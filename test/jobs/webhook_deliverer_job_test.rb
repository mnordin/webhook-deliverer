require "test_helper"

class WebhookDelivererJobTest < ActiveJob::TestCase
  test "updates the delivery status and responses for successful deliveries" do
    delivery = create(:webhook_delivery)
    successful_response = Faraday::Response.new(
      status: 200,
      body: { test: "success" }.to_json,
      url: delivery.url,
    )

    Webhooks::Deliverer.stub(:call, successful_response) do
      WebhookDelivererJob.new.perform(delivery.id)

      delivery.reload
      assert_equal "success", delivery.status
      assert_equal 200, delivery.last_response_code
      assert_equal({ test: "success" }.to_json, delivery.last_response)
      assert_equal 1, delivery.attempts
    end
  end

  test "can update a previously failed delivery to a successful one" do
    delivery = create(:webhook_delivery, :failed, attempts: 4)
    successful_response = Faraday::Response.new(
      status: 201,
      body: { success: true }.to_json,
      url: delivery.url,
    )

    Webhooks::Deliverer.stub(:call, successful_response) do
      WebhookDelivererJob.new.perform(delivery.id)
    end

    delivery.reload
    assert_equal "success", delivery.status
    assert_equal 201, delivery.last_response_code
    assert_equal({ success: true }.to_json, delivery.last_response)
    assert_equal 5, delivery.attempts
  end

  test "updates the delivery status and responses and raises an exception for unsuccessful deliveries" do
    delivery = create(:webhook_delivery)
    unsuccessful_response = Faraday::Response.new(
      status: 400,
      body: { test: "failure" }.to_json,
      url: delivery.url,
    )

    exception = assert_raises WebhookDelivererJob::UnsuccessfulDelivery do
      Webhooks::Deliverer.stub(:call, unsuccessful_response) do
        WebhookDelivererJob.new.perform(delivery.id)

        delivery.reload
        assert_equal "failure", delivery.status
        assert_equal 400, delivery.last_response_code
        assert_equal({ test: "failure" }.to_json, delivery.last_response)
        assert_equal 1, delivery.attempts
      end
    end

    assert_equal "Unsuccesful delivery for WebhookDelivery##{delivery.id}", exception.message
  end
end
