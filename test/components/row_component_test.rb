require "test_helper"

class RowComponentTest < ViewComponent::TestCase
  test "renders cells slots" do
    render_inline(RowComponent.new) do |row|
      row.with_cell { "Cell text" }
    end

    assert_selector "tr td", text: "Cell text"
  end

  test "allows passing any html attributes" do
    render_inline RowComponent.new(html: {data: {action: "click->gallery#next"}})

    assert_selector "tr[data-action=\"click->gallery#next\"]"
  end
end
