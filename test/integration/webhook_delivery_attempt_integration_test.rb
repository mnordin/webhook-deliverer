require "test_helper"

class WebhookDeliveryAttemptIntegrationTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper
  include ActionCable::TestHelper

  test "broadcasts the attempt creation to the webhook delivery stream" do
    webhook_delivery = create(:webhook_delivery)
    webhook_delivery_attempt = build(:webhook_delivery_attempt, webhook_delivery:)

    assert_turbo_stream_broadcasts(webhook_delivery.identity, count: 2) do
      perform_enqueued_jobs do
        webhook_delivery_attempt.save!
      end
    end
  end

  test "broadcasts a prepend action to webhook delivery attempts list on creation" do
    webhook_delivery = create(:webhook_delivery)
    webhook_delivery_attempt = build(
      :webhook_delivery_attempt,
      webhook_delivery:,
      response_code: 299
    )

    streams = perform_enqueued_jobs do
      capture_turbo_stream_broadcasts(webhook_delivery.identity) do
        webhook_delivery_attempt.save!
      end
    end
    prepend_stream = streams.find { |stream| stream["action"] == "prepend" }
    refute_nil prepend_stream, "No stream found with prepend action"

    assert_equal "webhook_delivery_attempts", prepend_stream["target"]
    assert_includes prepend_stream.inner_html, "SUCCESS"
    assert_includes prepend_stream.inner_html, "299"
  end

  test "broadcasts a update action to webhook delivery attributes on creation" do
    webhook_delivery = create(
      :webhook_delivery,
      url: "https://example.com/test",
      payload: {foo: "bar"}.to_json
    )
    webhook_delivery_attempt = build(
      :webhook_delivery_attempt,
      webhook_delivery:,
      response_code: 500
    )

    streams = perform_enqueued_jobs do
      capture_turbo_stream_broadcasts(webhook_delivery.identity) do
        webhook_delivery_attempt.save!
      end
    end
    update_stream = streams.find { |stream| stream["action"] == "update" }
    refute_nil update_stream, "No stream found with update action"

    assert_equal dom_id(webhook_delivery, :attributes), update_stream["target"]
    assert_includes update_stream.inner_html, "https://example.com/test"
    assert_includes update_stream.inner_html, {foo: "bar"}.to_json
    assert_includes update_stream.inner_html, "FAILURE"
    assert_includes update_stream.inner_html, "500"
  end
end
