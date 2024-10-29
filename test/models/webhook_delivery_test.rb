require "test_helper"

class WebhookDeliveryTest < ActiveSupport::TestCase
  test "is valid when status is set" do
    webhook_delivery = build(:webhook_delivery, status: nil)

    assert_not webhook_delivery.valid?
    assert_includes webhook_delivery.errors[:status], "can't be blank"
  end

  test "is valid when url is set" do
    webhook_delivery = build(:webhook_delivery, url: nil)

    assert_not webhook_delivery.valid?
    assert_includes webhook_delivery.errors[:url], "can't be blank"
  end
end
