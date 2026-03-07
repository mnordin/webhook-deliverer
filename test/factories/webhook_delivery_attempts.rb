FactoryBot.define do
  factory :webhook_delivery_attempt do
    response_code { 200 }
    response { nil }
    webhook_delivery
  end
end
