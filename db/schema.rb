# frozen_string_literal: true

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
# rubocop:disable Metrics/BlockLength
ActiveRecord::Schema.define(version: 20_230_715_131_012) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness',
                                                    unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.string 'service_name', null: false
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'active_storage_variant_records', force: :cascade do |t|
    t.bigint 'blob_id', null: false
    t.string 'variation_digest', null: false
    t.index %w[blob_id variation_digest], name: 'index_active_storage_variant_records_uniqueness', unique: true
  end

  create_table 'departments', force: :cascade do |t|
    t.string 'department_name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
  end

  create_table 'exam_performances', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'exam_id', null: false
    t.integer 'marks_obtained'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['exam_id'], name: 'index_exam_performances_on_exam_id'
    t.index ['user_id'], name: 'index_exam_performances_on_user_id'
  end

  create_table 'exams', force: :cascade do |t|
    t.bigint 'subject_id', null: false
    t.datetime 'start_time', null: false
    t.integer 'duration', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'exam_name', null: false
    t.boolean 'is_demo'
    t.index ['subject_id'], name: 'index_exams_on_subject_id'
  end

  create_table 'professors', force: :cascade do |t|
    t.string 'name', null: false
    t.bigint 'department_id', null: false
    t.text 'summary', null: false
    t.string 'linkedin_link'
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['department_id'], name: 'index_professors_on_department_id'
  end

  create_table 'questions', force: :cascade do |t|
    t.bigint 'exam_id', null: false
    t.text 'question_text', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'answer1', null: false
    t.string 'answer2', null: false
    t.string 'answer3', null: false
    t.string 'answer4', null: false
    t.integer 'correct_answer', null: false
    t.index ['exam_id'], name: 'index_questions_on_exam_id'
  end

  create_table 'registrations', force: :cascade do |t|
    t.bigint 'user_id', null: false
    t.bigint 'exam_id', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.boolean 'in_progress', default: false
    t.index ['exam_id'], name: 'index_registrations_on_exam_id'
    t.index ['user_id'], name: 'index_registrations_on_user_id'
  end

  create_table 'subjects', force: :cascade do |t|
    t.bigint 'department_id', null: false
    t.string 'subject_name', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.index ['department_id'], name: 'index_subjects_on_department_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'username', null: false
    t.string 'email', null: false
    t.string 'password_digest', null: false
    t.datetime 'created_at', precision: 6, null: false
    t.datetime 'updated_at', precision: 6, null: false
    t.string 'uid'
    t.string 'provider'
    t.string 'college'
    t.string 'department'
    t.boolean 'admin', default: false
    t.string 'magic_link_token'
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'active_storage_variant_records', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'exam_performances', 'exams'
  add_foreign_key 'exam_performances', 'users'
  add_foreign_key 'exams', 'subjects'
  add_foreign_key 'professors', 'departments'
  add_foreign_key 'questions', 'exams'
  add_foreign_key 'registrations', 'exams'
  add_foreign_key 'registrations', 'users'
  add_foreign_key 'subjects', 'departments'
end
# rubocop:enable Metrics/BlockLength
