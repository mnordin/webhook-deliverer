class Webhook < ApplicationRecord
  has_many :webhook_secrets

  validates :url, presence: true, format: { with: /\Ahttps:\/\//, message: "must be https protocol" }
end
