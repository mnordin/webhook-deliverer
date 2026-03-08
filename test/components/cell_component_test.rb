require "test_helper"

class CellComponentTest < ViewComponent::TestCase
  test "renders content within td" do
    render_inline CellComponent.new.with_content("Hello, World!")

    assert_selector "td", text: "Hello, World!"
  end

  test "allows passing any html attributes" do
    render_inline CellComponent.new(html: {data: {action: "click->gallery#next"}})

    assert_selector "td[data-action=\"click->gallery#next\"]"
  end

  test "allows passing in any css classes as a single string argument" do
    render_inline CellComponent.new(class_names: "foo bar")

    assert_selector "td.foo.bar"
  end

  test "allows passing in conditional css classes" do
    render_inline CellComponent.new(class_names: ["bar", {foo: false, zoom: true}])

    assert_selector "td.bar.zoom"
    refute_selector "td.foo"
  end
end
