# frozen_string_literal: true

# This is a sample class representing an model
class Exam < ApplicationRecord
  belongs_to :subject
  has_many :registrations
  has_many :users, through: :registrations
  has_many :questions
  has_many :exam_performances

  validates :exam_name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }
  validates :start_time, presence: true

  def shuffled_questions
    questions.to_a.shuffle
  end

  def calculate_score(user_answers)
    total_questions = questions.count
    score = 0
    questions.each_with_index do |question, index|
      score += 1 if user_answers[index.to_s].to_i == question.correct_answer
    end
    (score.to_f / total_questions) * 100
  end

  def create_exam_performance(user_id, marks_obtained)
    ExamPerformance.create(exam: self, user_id:, marks_obtained:)
  end

  def demo_exam
    Exam.find_by(subject_id:, is_demo: true)
  end

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "exams_#{Rails.env}"

  settings do
    mappings dynamic: 'false' do
      # Define the mappings for your Exam model attributes
      indexes :exam_name, type: 'text'
      indexes :start_time, type: 'date'
      indexes :duration, type: 'integer'
      # Add more mappings as needed
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.search_by_exam_name(search_term)
    search_definition = {
      size: 100,
      query: {
        match_phrase: {
          exam_name: {
            query: search_term.downcase
          }
        }
      }
    }
    __elasticsearch__.search(search_definition).records
  end
  # rubocop:enable Metrics/MethodLength

  def self.filter_by_department(department)
    search_definition = {
      query: {
        bool: {
          filter: {
            term: { "subject.department.department_name.keyword": department }
          }
        }
      }
    }
    __elasticsearch__.search(search_definition).records
  end

  def self.filter_by_subject(subject)
    search_definition = {
      query: {
        bool: {
          filter: {
            term: { "subject.subject_name.keyword": subject }
          }
        }
      }
    }
    __elasticsearch__.search(search_definition).records
  end

  after_commit -> { __elasticsearch__.index_document }, on: %i[create update]
  after_commit -> { __elasticsearch__.delete_document }, on: :destroy
end
