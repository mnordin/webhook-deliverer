module Webhooks
  class ProfileCreatedSerializer < ActiveModel::Serializer
    attributes(
      :type,
      :data
    )

    def type
      "profile_created"
    end

    def data
      ProfileSerializer.new(object)
    end
  end
end
