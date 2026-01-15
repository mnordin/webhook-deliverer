require "test_helper"

module Webhooks
  class DelivererTest < ActiveSupport::TestCase
    def stub_request_id_and_time(
      time: Time.zone.parse("2024-10-29 20:00:00"),
      request_id: "unique-request-id",
      &block
    )
      travel_to(time) do
        SecureRandom.stub(:uuid, request_id) do
          yield
        end
      end
    end

    test "it can deliver a webhook successfully" do
      stub_request_id_and_time do
        webhook_delivery = create(:webhook_delivery, url: "https://example.com/webhooks?foo=bar")
        response_body = {status: "success"}.to_json

        request = stub_request(:post, webhook_delivery.url).with(
          body: webhook_delivery.payload,
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/json",
            "User-Agent" => "Webhook Deliverer Client",
            "X-Request-Id" => "unique-request-id",
            "X-Timestamp" => "1730232000"
          }
        ).to_return(status: 200, body: response_body)

        response = Deliverer.call(webhook_delivery:)

        assert_instance_of Response, response
        assert_equal response.status, 200
        assert_equal response.body, response_body
        assert_requested request
      end
    end

    test "it returns a wrapped response" do
      webhook_delivery = create(:webhook_delivery)
      faraday_response = Faraday::Response.new(status: 404, body: "Not Found")
      request_stub = Minitest::Mock.new.expect(
        :post,
        faraday_response,
        [webhook_delivery.url, webhook_delivery.payload]
      )

      deliverer = Deliverer.new(webhook_delivery:)

      deliverer.stub(:connection, request_stub) do
        response = deliverer.call
        assert_instance_of Response, response
      end
      request_stub.verify
    end

    test "signs the request with a signature if the webhook has an active secret" do
      stub_request_id_and_time do
        webhook_delivery = create(:webhook_delivery, url: "https://example.com/webhooks?bar=baz")
        create(:webhook_secret,
          webhook: webhook_delivery.webhook_subscription.webhook,
          active: true,
          secret: "shared-secret")

        stub = stub_request(:post, webhook_delivery.url).with(
          body: webhook_delivery.payload,
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/json",
            "User-Agent" => "Webhook Deliverer Client",
            "X-Request-Id" => "unique-request-id",
            "X-Signature" => "02d0471a864cb18d96f8a124a0b62d165a5ea9a012f297ad6edb1fd7f1cf630d",
            "X-Timestamp" => "1730232000"
          }
        ).to_return(status: 201, body: "")

        response = Deliverer.call(webhook_delivery:)

        assert_equal response.status, 201
        assert_requested stub
      end
    end

    test "it bumps the webhook secrets last_used_at timestamp when used for the signature" do
      stub_request_id_and_time do
        webhook_delivery = create(:webhook_delivery)
        webhook_secret = create(
          :webhook_secret,
          webhook: webhook_delivery.webhook_subscription.webhook,
          active: true,
          last_used_at: nil
        )
        request_stub = Minitest::Mock.new.expect(
          :post,
          Faraday::Response.new,
          [webhook_delivery.url, webhook_delivery.payload]
        )

        deliverer = Deliverer.new(webhook_delivery:)

        deliverer.stub(:connection, request_stub) do
          deliverer.call
        end
        assert_equal webhook_secret.reload.last_used_at, Time.zone.now
        request_stub.verify
      end
    end

    test "does not sign the request using an inactive secret" do
      stub_request_id_and_time do
        webhook_delivery = create(:webhook_delivery, url: "https://example.com/webhooks?bar=baz")
        create(
          :webhook_secret,
          webhook: webhook_delivery.webhook_subscription.webhook,
          active: false,
          secret: "shared-secret"
        )

        stub = stub_request(:post, webhook_delivery.url).with(
          body: webhook_delivery.payload,
          headers: {
            "Accept" => "*/*",
            "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "Content-Type" => "application/json",
            "User-Agent" => "Webhook Deliverer Client",
            "X-Request-Id" => "unique-request-id",
            "X-Timestamp" => "1730232000"
          }
        ).to_return(status: 201, body: "")

        response = Deliverer.call(webhook_delivery:)

        assert_equal response.status, 201
        assert_requested stub
      end
    end
  end
end
