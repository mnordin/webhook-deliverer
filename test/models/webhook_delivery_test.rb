require "test_helper"

class WebhookDeliveryTest < ActiveSupport::TestCase
  test "is valid when status is set" do
    webhook_delivery = build(:webhook_delivery, status: nil)

    assert_not webhook_delivery.valid?
    assert webhook_delivery.errors[:status], "status is required"
  end
end
