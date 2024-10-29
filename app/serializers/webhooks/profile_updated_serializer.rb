module Webhooks
  class ProfileUpdatedSerializer < ActiveModel::Serializer
    attributes(
      :type,
      :data
    )

    def type
      "profile_updated"
    end

    def data
      ProfileSerializer.new(object)
    end
  end
end
