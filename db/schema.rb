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

ActiveRecord::Schema[7.2].define(version: 2026_02_03_002335) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accommodation_tags", force: :cascade do |t|
    t.string "name", null: false
    t.string "category", null: false
    t.text "description"
    t.integer "display_order", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_accommodation_tags_on_category"
    t.index ["name"], name: "index_accommodation_tags_on_name", unique: true
  end

  create_table "applications", force: :cascade do |t|
    t.bigint "job_seeker_id", null: false
    t.bigint "job_id", null: false
    t.integer "status", default: 0, null: false
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_applications_on_job_id"
    t.index ["job_seeker_id", "job_id"], name: "index_applications_on_job_seeker_id_and_job_id", unique: true
    t.index ["job_seeker_id"], name: "index_applications_on_job_seeker_id"
  end

  create_table "companies", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "company_name"
    t.string "location"
    t.integer "employee_count"
    t.string "industry"
    t.string "website_url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companies_on_user_id"
  end

  create_table "company_accommodations", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "accommodation_tag_id", null: false
    t.text "detail_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accommodation_tag_id"], name: "index_company_accommodations_on_accommodation_tag_id"
    t.index ["company_id", "accommodation_tag_id"], name: "index_company_accommodations_on_company_and_tag", unique: true
    t.index ["company_id"], name: "index_company_accommodations_on_company_id"
  end

  create_table "daily_reports", force: :cascade do |t|
    t.bigint "internship_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.date "report_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["internship_id", "user_id", "report_date"], name: "index_daily_reports_uniqueness", unique: true
    t.index ["internship_id"], name: "index_daily_reports_on_internship_id"
    t.index ["user_id"], name: "index_daily_reports_on_user_id"
  end

  create_table "internships", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.date "start_date", null: false
    t.date "end_date", null: false
    t.integer "status", default: 0, null: false
    t.text "company_feedback"
    t.text "job_seeker_feedback"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id", null: false
    t.bigint "job_seeker_id", null: false
    t.bigint "job_id", null: false
    t.index ["application_id"], name: "index_internships_on_application_id", unique: true
    t.index ["company_id"], name: "index_internships_on_company_id"
    t.index ["job_id"], name: "index_internships_on_job_id"
    t.index ["job_seeker_id"], name: "index_internships_on_job_seeker_id"
  end

  create_table "job_seeker_accommodations", force: :cascade do |t|
    t.bigint "job_seeker_id", null: false
    t.bigint "accommodation_tag_id", null: false
    t.integer "priority", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["accommodation_tag_id"], name: "index_job_seeker_accommodations_on_accommodation_tag_id"
    t.index ["job_seeker_id", "accommodation_tag_id"], name: "index_js_accommodations_on_js_and_tag", unique: true
    t.index ["job_seeker_id"], name: "index_job_seeker_accommodations_on_job_seeker_id"
  end

  create_table "job_seekers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "disability_type"
    t.boolean "disability_certificate"
    t.string "preferred_location"
    t.string "preferred_job_type"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_seekers_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "title", null: false
    t.string "job_type"
    t.text "description"
    t.string "location"
    t.integer "salary_min"
    t.integer "salary_max"
    t.boolean "internship_available", default: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["internship_available"], name: "index_jobs_on_internship_available"
    t.index ["status"], name: "index_jobs_on_status"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "application_id", null: false
    t.text "content"
    t.datetime "read_at"
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["application_id"], name: "index_messages_on_application_id"
    t.index ["recipient_id"], name: "index_messages_on_recipient_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "reporter_id", null: false
    t.string "target_type", null: false
    t.bigint "target_id", null: false
    t.integer "reason", default: 0, null: false
    t.text "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
    t.index ["status"], name: "index_reports_on_status"
    t.index ["target_type", "target_id"], name: "index_reports_on_target"
    t.index ["target_type", "target_id"], name: "index_reports_on_target_type_and_target_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", null: false
    t.integer "user_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "applications", "job_seekers"
  add_foreign_key "applications", "jobs"
  add_foreign_key "companies", "users"
  add_foreign_key "company_accommodations", "accommodation_tags"
  add_foreign_key "company_accommodations", "companies"
  add_foreign_key "daily_reports", "internships"
  add_foreign_key "daily_reports", "users"
  add_foreign_key "internships", "applications"
  add_foreign_key "internships", "companies"
  add_foreign_key "internships", "job_seekers"
  add_foreign_key "internships", "jobs"
  add_foreign_key "job_seeker_accommodations", "accommodation_tags"
  add_foreign_key "job_seeker_accommodations", "job_seekers"
  add_foreign_key "job_seekers", "users"
  add_foreign_key "jobs", "companies"
  add_foreign_key "messages", "applications"
  add_foreign_key "messages", "users", column: "recipient_id"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "reports", "users", column: "reporter_id"
end
