class WebhookSecret < ApplicationRecord
  belongs_to :webhook

  attribute :secret, default: -> { SecureRandom.uuid }

  scope :active, -> { where(active: true) }

  validates :secret, presence: true, uniqueness: {scope: :webhook_id}
  validates :active, uniqueness: {scope: :webhook_id}, if: :active?
end
