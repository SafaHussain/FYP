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

ActiveRecord::Schema.define(version: 2023_06_06_142017) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcement_managers", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "course_id"
    t.index ["course_id"], name: "index_announcement_managers_on_course_id"
  end

  create_table "announcements", force: :cascade do |t|
    t.text "announcement_content"
    t.boolean "pinned"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "announcement_manager_id"
    t.index ["announcement_manager_id"], name: "index_announcements_on_announcement_manager_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "sender_id"
    t.integer "recipient_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "course_registrations", force: :cascade do |t|
    t.string "status"
    t.bigint "course_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "grade"
    t.bigint "user_id", null: false
    t.index ["course_id"], name: "index_course_registrations_on_course_id"
    t.index ["user_id"], name: "index_course_registrations_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "course_name"
    t.string "course_code"
    t.integer "capacity"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "semester_id"
    t.bigint "teacher_id"
    t.bigint "department_id"
    t.bigint "announcement_manager_id"
    t.index ["announcement_manager_id"], name: "index_courses_on_announcement_manager_id"
    t.index ["department_id"], name: "index_courses_on_department_id"
    t.index ["semester_id"], name: "index_courses_on_semester_id"
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "deliverables", force: :cascade do |t|
    t.integer "weight", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "course_id"
    t.string "title"
    t.string "type"
    t.string "instructions"
    t.text "encrypted_file"
    t.string "hashfile"
    t.index ["course_id"], name: "index_deliverables_on_course_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "documents", force: :cascade do |t|
    t.text "encrypted_file"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "email_notifications", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "keys", force: :cascade do |t|
    t.binary "key"
    t.bigint "resource_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "deliverable_id"
    t.index ["deliverable_id"], name: "index_keys_on_deliverable_id"
    t.index ["resource_id"], name: "index_keys_on_resource_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "conversation_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "student_id"
    t.integer "course_id"
    t.bigint "user_id"
    t.string "message"
    t.string "type"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "hyperlink"
    t.bigint "course_id"
    t.string "title"
    t.string "description"
    t.text "encrypted_file"
    t.string "file"
    t.string "hashfile"
    t.index ["course_id"], name: "index_resources_on_course_id"
  end

  create_table "semesters", force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.date "registration_deadline"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.bigint "department_id", null: false
    t.index ["department_id"], name: "index_semesters_on_department_id"
    t.index ["name"], name: "index_semesters_on_name"
  end

  create_table "submissions", force: :cascade do |t|
    t.bigint "deliverable_id"
    t.bigint "user_id", null: false
    t.string "hyperlink"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "grade"
    t.string "comment"
    t.index ["deliverable_id"], name: "index_submissions_on_deliverable_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "student_id"
    t.integer "announcement_manager_id"
  end

  create_table "text_notifications", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "user_registrations", force: :cascade do |t|
    t.string "status"
    t.string "user_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_registrations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "email"
    t.string "user_type"
    t.string "gender"
    t.integer "age"
    t.text "public_key"
  end

  create_table "web_notifications", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "course_registrations", "courses"
  add_foreign_key "course_registrations", "users"
  add_foreign_key "keys", "deliverables"
  add_foreign_key "keys", "resources"
  add_foreign_key "semesters", "departments"
  add_foreign_key "submissions", "deliverables"
  add_foreign_key "submissions", "users"
  add_foreign_key "user_registrations", "users"
end
