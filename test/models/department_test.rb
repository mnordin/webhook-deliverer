require "test_helper"

class DepartmentTest < ActiveSupport::TestCase
  test "name must be set" do
    department = build(:department, name: nil)

    refute department.valid?
    assert_includes department.errors[:name], "can't be blank"
  end
end
