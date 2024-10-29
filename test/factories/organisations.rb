FactoryBot.define do
  factory :organisation do
    name { "LucasArts Games" }

    trait :with_webhook do
      webhook
    end
  end
end
