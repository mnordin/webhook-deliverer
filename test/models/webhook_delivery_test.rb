require "test_helper"

class WebhookDeliveryTest < ActiveSupport::TestCase
  test ".last_delivery_attempt returns the last delivery attempt by creation timestamp" do
    webhook_delivery = create(:webhook_delivery)
    create_list(:webhook_delivery_attempt, 2, webhook_delivery:)
    last_delivery_attempt = create(:webhook_delivery_attempt, webhook_delivery:)

    assert_equal last_delivery_attempt, webhook_delivery.last_delivery_attempt
  end

  test "is valid when url is set" do
    webhook_delivery = build(:webhook_delivery, url: nil)

    refute webhook_delivery.valid?
    assert_includes webhook_delivery.errors[:url], "can't be blank"
  end
end
