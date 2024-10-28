FactoryBot.define do
  factory :user do
    name { "Manny Calavera" }
    work_email { "manny@lucasarts.com" }
    personal_email { "manny@gmail.com" }
    job_title { "Sea Captain" }
    first_day_of_work { "2024-10-28" }
    department

    trait :with_manager do
      manager { create(:user) }
    end
  end
end
