require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "it is valid when name, work email and department are set" do
    user = build(
      :user,
      name: "Glottis",
      work_email: "glottis@lucasarts.com",
      department: build(:department)
    )

    assert user.valid?
  end

  test "it must have name set" do
    user = build(:user, name: nil)

    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "it must have work email set" do
    user = build(:user, work_email: nil)

    assert_not user.valid?
    assert_includes user.errors[:work_email], "can't be blank"
  end

  test "it must belong to a department" do
    user = build(:user, department: nil)

    assert_not user.valid?
    assert_includes user.errors[:department], "must exist"
  end

  class Callbacks < ActiveSupport::TestCase
    include ActiveJob::TestHelper

    test "enqueues a webhook when user is created and has a matching subscription" do
      subscription = create(:webhook_subscription, event: "profile_created")
      organisation = create(:organisation, webhook: subscription.webhook)
      department = create(:department, organisation:)
      glottis = build(
        :user,
        name: "Glottis",
        work_email: "glottis@lucasarts.com",
        department:,
      )

      assert_enqueued_jobs 1, only: Webhooks::ProfileCreatedWebhookDeliveryJob do
        glottis.save!
      end
    end

    test "does not enqueue a webhook when user is created without a matching subscription" do
      organisation = create(:organisation, :with_webhook)
      department = create(:department, organisation:)
      glottis = build(
        :user,
        name: "Glottis",
        work_email: "glottis@lucasarts.com",
        department:,
      )

      assert_enqueued_jobs 0 do
        glottis.save!
      end
    end

    test "enqueues a webhook when user is updated and has a matching subscription" do
      organisation = create(:organisation, webhook: build(:webhook))
      create(:webhook_subscription, event: "profile_updated", webhook: organisation.webhook)
      department = create(:department, organisation:)
      glottis = create(
        :user,
        name: "Glottis",
        work_email: "glottis@lucasarts.com",
        department:,
      )

      assert_enqueued_jobs 1, only: Webhooks::ProfileUpdatedWebhookDeliveryJob do
        glottis.update(job_title: "Pianist")
      end
    end

    test "does not enqueue a webhook when user is updated without a matching subscription" do
      organisation = create(:organisation, :with_webhook)
      department = create(:department, organisation:)
      glottis = build(
        :user,
        name: "Glottis",
        work_email: "glottis@lucasarts.com",
        department:,
      )

      assert_enqueued_jobs 0 do
        glottis.save!
      end
    end

    test "it does not enqueue a webhook when the user has no meaningful updates" do
      organisation = create(:organisation, webhook: build(:webhook))
      create(:webhook_subscription, event: "profile_updated", webhook: organisation.webhook)
      department = create(:department, organisation:)
      glottis = create(
        :user,
        name: "Glottis",
        work_email: "glottis@lucasarts.com",
        department:,
      )

      assert_enqueued_jobs 0 do
        glottis.update(updated_at: Time.zone.now)
      end
    end
  end
end
