module Webhooks
  class ProfileArchivedSerializer < ActiveModel::Serializer
    attributes(
      :type,
      :data
    )

    def type
      "profile_archived"
    end

    def data
      ProfileSerializer.new(object)
    end
  end
end
