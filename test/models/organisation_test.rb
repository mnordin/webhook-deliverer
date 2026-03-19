require "test_helper"

class OrganisationTest < ActiveSupport::TestCase
  test "name must be set" do
    organisation = build(:organisation, name: nil)

    refute organisation.valid?
    assert_includes organisation.errors[:name], "can't be blank"
  end
end
