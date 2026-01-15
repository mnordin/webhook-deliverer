require "test_helper"

class ProfileSerializerTest < ActiveSupport::TestCase
  test "it can serialize a user into a profile" do
    freeze_time do
      glottis = build(:user, name: "Glottis")
      manny = create(
        :user,
        name: "Manny Calavera",
        work_email: "manny@lucasarts.com",
        personal_email: "manny@gmail.com",
        job_title: "Entrepreneur",
        first_day_of_work: "2024-06-01",
        manager: glottis
      )

      profile = Webhooks::ProfileSerializer.new(manny).as_json

      assert_equal profile, {
        id: manny.id,
        name: "Manny Calavera",
        work_email: "manny@lucasarts.com",
        personal_email: "manny@gmail.com",
        job_title: "Entrepreneur",
        first_day_of_work: "2024-06-01",
        created_at: Time.zone.now.iso8601,
        updated_at: Time.zone.now.iso8601,
        manager_name: "Glottis"
      }
    end
  end

  test "it returns nil for manager_name if manager is not set" do
    user = create(:user, manager: nil)

    profile = Webhooks::ProfileSerializer.new(user).as_json

    assert_nil profile[:manager_name]
  end
end
