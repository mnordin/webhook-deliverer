class WebhookSubscription < ApplicationRecord
  belongs_to :webhook

  enum :event, { profile_created: 0, profile_updated: 1, profile_archived: 2 }

  validates :event, presence: true
end
