class WebhookSecret < ApplicationRecord
  belongs_to :webhook

  encrypts :secret

  scope :active, -> { where(active: true) }

  before_validation :set_default_secret, on: :create

  validates :secret, presence: true, uniqueness: {scope: :webhook_id}
  validates :active, uniqueness: {scope: :webhook_id}, if: :active?

  private

  def set_default_secret
    self.secret ||= SecureRandom.uuid
  end
end
