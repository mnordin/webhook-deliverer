require "test_helper"

class TableComponentTest < ViewComponent::TestCase
  test "renders headers and rows slots" do
    render_inline(TableComponent.new) do |table|
      table.with_header { "Header" }
      table.with_row do |row|
        row.with_cell { "Cell" }
      end
    end

    assert_selector "table thead tr th", text: "Header"
    assert_selector "table tbody tr td", text: "Cell"
  end

  test "allows passing any html attributes" do
    render_inline TableComponent.new(html: {data: {controller: "foobar"}})

    assert_selector "table[data-controller=\"foobar\"]"
  end
end
