module Webhooks
  class ProfileSerializer < ActiveModel::Serializer
    attributes(
      :id,
      :name,
      :work_email,
      :personal_email,
      :job_title,
      :first_day_of_work,
      :created_at,
      :updated_at,
      :manager_name
    )

    def first_day_of_work
      object.first_day_of_work&.iso8601
    end

    def created_at
      object.created_at.utc.iso8601
    end

    def updated_at
      object.updated_at.utc.iso8601
    end

    def manager_name
      object.manager&.name
    end
  end
end
