require "test_helper"

class ResponseCodeBadgeComponentTest < ViewComponent::TestCase
  test "renders success badge for successful response codes" do
    [200, 201, 299].each do |code|
      render_inline ResponseCodeBadgeComponent.new(response_code: code)

      assert_selector "span", text: "SUCCESS"
      assert_selector "span.bg-green-200"
    end
  end

  test "renders failure badge for unsuccessful response codes" do
    [301, 404, 500].each do |code|
      render_inline ResponseCodeBadgeComponent.new(response_code: code)

      assert_selector "span", text: "FAILURE"
      assert_selector "span.bg-red-200"
    end
  end

  test "renders pending badge for nil code" do
    render_inline ResponseCodeBadgeComponent.new(response_code: nil)

    assert_selector "span", text: "PENDING"
    assert_selector "span.bg-slate-200"
  end
end
