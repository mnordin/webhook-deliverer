class User < ApplicationRecord
  validates :name, :work_email, presence: true

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :department
  has_one :organisation, through: :department

  after_commit :deliver_profile_created_webhook, on: :create

  private

  def deliver_profile_created_webhook
    if profile_created_subscription = find_webhook_subscription("profile_created")
      Webhooks::ProfileCreatedWebhookDeliveryJob.perform_later(self, profile_created_subscription)
    end
  end

  def find_webhook_subscription(event_name)
    organisation&.webhook&.webhook_subscriptions&.find_by(event: event_name)
  end
end
