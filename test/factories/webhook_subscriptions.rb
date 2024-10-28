FactoryBot.define do
  factory :webhook_subscription do
    event { "profile_created" }
    relative_path { "/profiles" }
    webhook
  end
end
