class Organisation < ApplicationRecord
  has_many :departments
  has_one :webhook

  validates :name, presence: true
end
