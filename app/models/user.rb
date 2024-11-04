class User < ApplicationRecord
  validates :name, :work_email, presence: true

  belongs_to :manager, class_name: "User", optional: true
  belongs_to :department
  has_one :organisation, through: :department

  after_commit :deliver_profile_created_webhook, on: :create
  after_commit :deliver_profile_updated_webhook, on: :update

  private

  def deliver_profile_created_webhook
    if profile_created_subscription = find_webhook_subscription("profile_created")
      Webhooks::ProfileCreatedWebhookDeliveryJob.perform_later(self, profile_created_subscription)
    end
  end

  def deliver_profile_updated_webhook
    if (self.previous_changes.keys - [ "updated_at" ]).any?
      if profile_updated_subscription = find_webhook_subscription("profile_updated")
        Webhooks::ProfileUpdatedWebhookDeliveryJob.perform_later(self, profile_updated_subscription)
      end
    end
  end

  def find_webhook_subscription(event_name)
    WebhookSubscription.
      joins(webhook: { organisation: :departments }).
      where(departments: { id: department_id }).
      find_by(event: event_name)
  end
end
