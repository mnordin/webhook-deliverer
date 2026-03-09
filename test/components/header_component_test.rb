require "test_helper"

class HeaderComponentTest < ViewComponent::TestCase
  test "renders content within th" do
    render_inline HeaderComponent.new.with_content("Hello, World!")

    assert_selector "th", text: "Hello, World!"
  end

  test "allows passing any html attributes" do
    render_inline HeaderComponent.new(html: {data: {action: "click->gallery#next"}})

    assert_selector "th[data-action=\"click->gallery#next\"]"
  end

  test "allows passing in any css classes as a single string argument" do
    render_inline HeaderComponent.new(class_names: "foo bar")

    assert_selector "th.foo.bar"
  end

  test "allows passing in conditional css classes" do
    render_inline HeaderComponent.new(class_names: ["bar", {foo: false, zoom: true}])

    assert_selector "th.bar.zoom"
    refute_selector "th.foo"
  end
end
