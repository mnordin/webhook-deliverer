class User < ApplicationRecord
  validates :name, :work_email, presence: true

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :department
  has_one :organisation, through: :department
end
