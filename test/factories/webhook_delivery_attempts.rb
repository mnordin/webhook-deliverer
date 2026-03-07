FactoryBot.define do
  factory :webhook_delivery_attempt do
    response_code { 200 }
    response { nil }
    webhook_delivery

    trait :failure do
      response_code { 500 }
      response { "Internal Server Error" }
    end
  end
end
