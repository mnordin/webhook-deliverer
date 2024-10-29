require "test_helper"

module Webhooks
  class ProfileCreatedSerializerTest < ActiveSupport::TestCase
    test "it can serialize a user into a profile created event" do
      user = create(:user)

      serializer = ProfileCreatedSerializer.new(user)

      assert_equal serializer.to_json, {
        type: "profile_created",
        data: ProfileSerializer.new(user)
      }.to_json
    end
  end
end
