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

ActiveRecord::Schema.define(version: 2023_06_29_100256) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "departments", force: :cascade do |t|
    t.string "department_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "exam_performances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exam_id", null: false
    t.integer "marks_obtained"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["exam_id"], name: "index_exam_performances_on_exam_id"
    t.index ["user_id"], name: "index_exam_performances_on_user_id"
  end

  create_table "exams", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.datetime "start_time"
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "exam_name"
    t.index ["subject_id"], name: "index_exams_on_subject_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "exam_id", null: false
    t.text "question_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "answer1"
    t.string "answer2"
    t.string "answer3"
    t.string "answer4"
    t.integer "correct_answer"
    t.index ["exam_id"], name: "index_questions_on_exam_id"
  end

  create_table "registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exam_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "in_progress", default: false
    t.index ["exam_id"], name: "index_registrations_on_exam_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.bigint "department_id", null: false
    t.string "subject_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["department_id"], name: "index_subjects_on_department_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "uid"
    t.string "provider"
    t.string "college"
    t.string "department"
    t.boolean "admin", default: false
    t.string "magic_link_token"
  end

  add_foreign_key "exam_performances", "exams"
  add_foreign_key "exam_performances", "users"
  add_foreign_key "exams", "subjects"
  add_foreign_key "questions", "exams"
  add_foreign_key "registrations", "exams"
  add_foreign_key "registrations", "users"
  add_foreign_key "subjects", "departments"
end
