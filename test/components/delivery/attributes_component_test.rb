require "test_helper"

module Delivery
  class AttributesComponentTest < ViewComponent::TestCase
    test "renders rows with values" do
      render_inline(AttributesComponent.new) do |c|
        c.with_row(grid_cols: 4) do |row|
          row.with_value(title: "Name") { "Test" }
        end
      end

      assert_selector ".grid-cols-4"
      assert_selector "h3", text: "Name"
      assert_selector "div", text: "Test"
    end

    test "renders multiple rows" do
      render_inline(AttributesComponent.new) do |c|
        c.with_row(grid_cols: 4) do |row|
          row.with_value(title: "Status") { "Active" }
        end
        c.with_row(grid_cols: 2) do |row|
          row.with_value(title: "Details") { "Info" }
        end
      end

      assert_selector ".grid-cols-4", count: 1
      assert_selector ".grid-cols-2", count: 1
    end

    test "value with info size spans one column" do
      render_inline(AttributesComponent.new) do |c|
        c.with_row(grid_cols: 4) do |row|
          row.with_value(title: "Status", size: :info) { "OK" }
        end
      end

      assert_selector ".col-span-1"
    end

    test "value with detail size spans two columns" do
      render_inline(AttributesComponent.new) do |c|
        c.with_row(grid_cols: 2) do |row|
          row.with_value(title: "Payload", size: :detail) { "{}" }
        end
      end

      assert_selector ".col-span-2"
    end

    test "renders multiple values in a row" do
      render_inline(AttributesComponent.new) do |c|
        c.with_row(grid_cols: 4) do |row|
          row.with_value(title: "First") { "1" }
          row.with_value(title: "Second") { "2" }
        end
      end

      assert_selector "h3", text: "First"
      assert_selector "h3", text: "Second"
      assert_selector ".grid-cols-4 h3", count: 2
    end
  end
end
