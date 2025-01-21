require "test_helper"

class WebhookDeliveryComponentTest < ActionView::TestCase
  include ViewComponent::TestHelpers

  test "renders a webhook delivery row" do
    webhook_delivery = create(:webhook_delivery, :success)

    output = render_inline(WebhookDeliveryComponent.new(webhook_delivery:)).to_html

    assert_includes(output, webhook_delivery.id.to_s)
    assert_includes(output, "success")
    assert_includes(output, webhook_delivery.url)
    assert_includes(output, webhook_delivery.attempts.to_s)
    assert_includes(output, webhook_delivery.last_response_code.to_s)
    assert_includes(output, webhook_delivery.last_response)
    assert_includes(output, webhook_delivery.payload)
    assert_includes(output, "bg-green-200")
  end

  test "renders an unsuccessful webhook delivery row" do
    webhook_delivery = create(:webhook_delivery, :failed)

    output = render_inline(WebhookDeliveryComponent.new(webhook_delivery:)).to_html

    assert_includes(output, "failure")
    assert_includes(output, "bg-red-200")
  end

  test "renders a pending webhook delivery row" do
    webhook_delivery = create(:webhook_delivery)
    output = render_inline(WebhookDeliveryComponent.new(webhook_delivery:)).to_html

    assert_includes(output, "pending")
    assert_includes(output, "bg-slate-200")
  end
end
