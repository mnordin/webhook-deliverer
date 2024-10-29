FactoryBot.define do
  factory :webhook do
    organisation
    url { "https://example.com" }
  end
end
