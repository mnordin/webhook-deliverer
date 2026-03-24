require "test_helper"

module Table
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

    test "allows passing in any css classes as a single string argument" do
      render_inline RowComponent.new(class_names: "foo bar")

      assert_selector "tr.foo.bar"
    end

    test "allows passing in conditional css classes" do
      render_inline RowComponent.new(class_names: ["bar", {foo: false, zoom: true}])

      assert_selector "tr.bar.zoom"
      refute_selector "tr.foo"
    end
  end
end
