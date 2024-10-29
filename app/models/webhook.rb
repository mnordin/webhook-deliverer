class Webhook < ApplicationRecord
  has_many :webhook_secrets
  has_many :webhook_subscriptions
  belongs_to :organisation

  validates :url, presence: true, format: { with: /\Ahttps:\/\/.*\z/, message: "must be https protocol" }
end
