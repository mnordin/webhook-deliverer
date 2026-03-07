require "test_helper"

class StatusBadgeComponentTest < ViewComponent::TestCase
  test "renders success badge with green colors" do
    render_inline StatusBadgeComponent.new(status: :success)

    assert_selector "span.bg-green-200.text-green-700.inset-ring-green-500\\/10"
  end

  test "renders failure badge with red colors" do
    render_inline StatusBadgeComponent.new(status: :failure)

    assert_selector "span.bg-red-200.text-red-700.inset-ring-red-500\\/10"
  end
end
