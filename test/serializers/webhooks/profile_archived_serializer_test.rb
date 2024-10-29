require "test_helper"

module Webhooks
  class ProfileArchivedSerializerTest < ActiveSupport::TestCase
    test "it can serialize a user into a profile archived event" do
      user = create(:user)

      serializer = ProfileArchivedSerializer.new(user)

      assert_equal serializer.to_json, {
        type: "profile_archived",
        data: ProfileSerializer.new(user)
      }.to_json
    end
  end
end
