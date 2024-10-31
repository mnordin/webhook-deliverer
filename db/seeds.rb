# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

organisation = Organisation.find_or_create_by!(name: "LucasArts Games")

department_of_death = Department.find_or_create_by!(name: "Department of Death", organisation:)

User.find_or_create_by!(
  name: "Manny Calavera",
  work_email: "manny@lucasarts.com",
  personal_email: "manny@gmail.com",
  job_title: "Entrepreneur",
  department: department_of_death,
)

User.find_or_create_by!(
  name: "Glottis",
  work_email: "glottis@lucasarts.com",
  personal_email: "glottis@gmail.com",
  job_title: "Mechanic",
  department: department_of_death,
  manager: User.find_by!(name: "Manny Calavera"),
)

monkey_island = Department.find_or_create_by!(name: "Monkey Island", organisation:)

User.find_or_create_by!(
  name: "Guybrush Threepwood",
  work_email: "guybrush@lucasarts.com",
  personal_email: "guybrush@gmail.com",
  department: monkey_island,
  job_title: "Pirate",
)

webhook = Webhook.find_or_create_by!(url: "https://example.com", organisation:)

WebhookSubscription.events.keys.each do |event|
  WebhookSubscription.find_or_create_by!(
    webhook:,
    event:,
    relative_path: "/profiles"
  )
end

WebhookSecret.find_or_create_by!(webhook:, active: true)
WebhookSecret.find_or_create_by!(webhook:, active: false)
