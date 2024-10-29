require "test_helper"

module Webhooks
  class ProfileUpdatedSerializerTest < ActiveSupport::TestCase
    test "it can serialize a user into a profile updated event" do
      user = create(:user)

      serializer = ProfileUpdatedSerializer.new(user)

      assert_equal serializer.to_json, {
        type: "profile_updated",
        data: ProfileSerializer.new(user)
      }.to_json
    end
  end
end
