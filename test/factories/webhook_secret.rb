FactoryBot.define do
  factory :webhook_secret do
    secret { SecureRandom.uuid }
    active { false }
    last_used_at { nil }
    webhook

    trait :active do
      active { true }
    end
  end
end
