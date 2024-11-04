require "test_helper"

class WebhookTest < ActiveSupport::TestCase
  test "is valid when url is set to https" do
    webhook = build(:webhook, url: "https://example.com")

    assert webhook.valid?
  end

  test "is invalid when url is using http" do
    webhook = build(:webhook, url: "http://example.com")

    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "must be https protocol"
  end

  test "allows http if the domain is localhost" do
    webhook = build(:webhook, url: "http://localhost:4000")

    assert webhook.valid?
  end

  test "allows http if the domain is 127.0.0.1" do
    webhook = build(:webhook, url: "http://127.0.0.1/webhooks")

    assert webhook.valid?
  end

  test "is invalid when url lacks procotol" do
    webhook = build(:webhook, url: "example.com")

    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "must be https protocol"
  end

  test "is invalid when url is blank" do
    webhook = build(:webhook, url: "")

    assert_not webhook.valid?
    assert_includes webhook.errors[:url], "can't be blank"
  end
end
