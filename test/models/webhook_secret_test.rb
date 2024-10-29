require "test_helper"

class WebhookSecretTest < ActiveSupport::TestCase
  test "it generates a shared secret unless explicitly set" do
    SecureRandom.stub(:uuid, "123-456-789") do
      webhook_secret = WebhookSecret.new

      assert_equal "123-456-789", webhook_secret.secret
    end
  end

  test "does not overwrite secret when explicitly setting it" do
    SecureRandom.stub(:uuid, "123-456-789") do
      webhook_secret = WebhookSecret.new(secret: "foo-bar")

      assert_equal "foo-bar", webhook_secret.secret
    end
  end

  test "only allows one active webhook secret per webhook" do
    active_secret = create(:webhook_secret, :active)
    second_active_secret = build(:webhook_secret, :active, webhook: active_secret.webhook)

    assert_not second_active_secret.valid?
    assert_includes second_active_secret.errors[:active], "has already been taken"
  end

  test "allows multiple active secrets for separate webhooks" do
    _active_secret = create(:webhook_secret, :active)
    second_active_secret = build(:webhook_secret, :active)

    assert second_active_secret.valid?
  end
end
