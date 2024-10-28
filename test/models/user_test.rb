require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "it is valid when name, work email and department are set" do
    user = build(
      :user,
      name: "Glottis",
      work_email: "glottis@lucasarts.com",
      department: build(:department)
    )

    assert user.valid?
  end

  test "it must have name set" do
    user = build(:user, name: nil)

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "it must have work email set" do
    user = build(:user, work_email: nil)

    assert_not user.valid?
    assert_includes user.errors[:work_email], "can't be blank"
  end

  test "it must belong to a department" do
    user = build(:user, department: nil)

    assert_not user.valid?
    assert_includes user.errors[:department], "must exist"
  end
end
