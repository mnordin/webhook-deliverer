require "test_helper"

class CellComponentTest < ViewComponent::TestCase
  test "renders content within td" do
    render_inline CellComponent.new.with_content("Hello, World!")

    assert_selector "td", text: "Hello, World!"
  end

  test "renders mono variants with different font family" do
    render_inline CellComponent.new(variant: :mono).with_content("Foobar")

    assert_selector "td.font-mono", text: "Foobar"
  end

  test "allows passing any html attributes" do
    render_inline CellComponent.new(html: {data: {action: "click->gallery#next"}})

    assert_selector "td[data-action=\"click->gallery#next\"]"
  end
end
