FactoryBot.define do
  factory :webhook_delivery do
    status { 0 }
    attempts { 0 }
    last_response_code { nil }
    last_response { nil }
    payload {
       { type: "profile_created", data: { id: 1 } }.to_json
    }
    webhook_subscription { build(:webhook_subscription, event: "profile_created") }

    trait :profile_updated do
      payload {
        { type: "profile_updated", data: { id: 1 } }.to_json
      }
      webhook_subscription { build(:webhook_subscription, event: "profile_updated") }
    end

    trait :profile_archived do
      payload {
        { type: "profile_archived", data: { id: 1 } }.to_json
      }
      webhook_subscription { build(:webhook_subscription, event: "profile_archived") }
    end
  end
end