# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2024_11_02_114058) do
  create_table "departments", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organisation_id"
    t.index ["organisation_id"], name: "index_departments_on_organisation_id"
  end

  create_table "organisations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "work_email", null: false
    t.string "personal_email"
    t.string "job_title"
    t.date "first_day_of_work"
    t.integer "manager_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department_id", null: false
    t.index ["department_id"], name: "index_users_on_department_id"
    t.index ["manager_id"], name: "index_users_on_manager_id"
  end

  create_table "webhook_deliveries", force: :cascade do |t|
    t.integer "status", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.integer "last_response_code"
    t.text "last_response"
    t.json "payload", null: false
    t.string "url", null: false
    t.integer "webhook_subscription_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_subscription_id"], name: "index_webhook_deliveries_on_webhook_subscription_id"
  end

  create_table "webhook_secrets", force: :cascade do |t|
    t.string "secret", null: false
    t.boolean "active", default: false, null: false
    t.datetime "last_used_at"
    t.integer "webhook_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_id", "active"], name: "index_webhook_secrets_on_webhook_id_and_active", unique: true, where: "active IS TRUE"
    t.index ["webhook_id", "secret"], name: "index_webhook_secrets_on_webhook_id_and_secret", unique: true
    t.index ["webhook_id"], name: "index_webhook_secrets_on_webhook_id"
  end

  create_table "webhook_subscriptions", force: :cascade do |t|
    t.integer "event", default: 0, null: false
    t.string "relative_path"
    t.integer "webhook_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["webhook_id"], name: "index_webhook_subscriptions_on_webhook_id"
  end

  create_table "webhooks", force: :cascade do |t|
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "organisation_id", null: false
    t.index ["organisation_id"], name: "index_webhooks_on_organisation_id"
  end

  add_foreign_key "departments", "organisations"
  add_foreign_key "users", "departments"
  add_foreign_key "users", "users", column: "manager_id"
  add_foreign_key "webhook_deliveries", "webhook_subscriptions"
  add_foreign_key "webhook_secrets", "webhooks"
  add_foreign_key "webhook_subscriptions", "webhooks"
  add_foreign_key "webhooks", "organisations"
end
