FactoryBot.define do
  factory :webhook_delivery do
    url { "https://example.com/webhooks/profiles" }
    payload do
      {type: "profile_created", data: {id: 1}}.to_json
    end
    webhook_subscription { build(:webhook_subscription, event: "profile_created") }

    trait :profile_updated do
      payload do
        {type: "profile_updated", data: {id: 1}}.to_json
      end
      webhook_subscription { build(:webhook_subscription, event: "profile_updated") }
    end

    trait :profile_archived do
      payload do
        {type: "profile_archived", data: {id: 1}}.to_json
      end
      webhook_subscription { build(:webhook_subscription, event: "profile_archived") }
    end

    trait :failed do
      after(:create) do |delivery|
        create(:webhook_delivery_attempt, :failure, webhook_delivery: delivery)
      end
    end
  end
end
