module Webhooks
  class Deliverer
    def self.call(**args)
      new(**args).call
    end

    def initialize(webhook_delivery:)
      @webhook_delivery = webhook_delivery
    end

    def call
      response = connection.post(url, webhook_delivery.payload)

      webhook_secret&.update(last_used_at: Time.zone.now)

      Response.new(response)
    end

    private

    attr_reader :webhook_delivery

    def connection
      Faraday.new(url:) do |connection|
        connection.adapter :net_http
        connection.headers["User-Agent"] = "Webhook Deliverer Client"
        connection.headers["Content-Type"] = "application/json"
        connection.headers["X-Timestamp"] = Time.zone.now.to_i.to_s
        connection.headers["X-Signature"] = signature if signature
        connection.headers["X-Request-Id"] = SecureRandom.uuid
      end
    end

    def signature
      return nil unless webhook_secret

      digest = OpenSSL::Digest.new("sha256")
      OpenSSL::HMAC.hexdigest(digest, webhook_secret.secret, webhook_delivery.payload)
    end

    def webhook_secret
      webhook.webhook_secrets.active.first
    end

    def url
      webhook_delivery.url
    end

    def webhook
      @webhook ||= webhook_delivery.webhook_subscription.webhook
    end
  end
end
