# frozen_string_literal: true

# This is a class representing an model
class Exam < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :subject
  has_many :registrations, dependent: :destroy
  has_many :users, through: :registrations
  has_many :questions, dependent: :destroy
  has_many :exam_performances, dependent: :destroy

  validates :exam_name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }
  validates :subject_id, presence: { message: 'Please select subject' }
  validate :start_time_must_be_future, on: :create
  validates :start_time, presence: { message: 'Time cannot be blank' }
  validates :duration, presence: true, numericality: { greater_than: 0, message: 'must be greater than zero' }

  def start_time_must_be_future
    return unless start_time.present? && start_time <= DateTime.now

    errors.add(:start_time, 'must be in the future')
  end

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

  index_name "exams_#{Rails.env}"

  settings do
    mappings dynamic: 'false' do
      indexes :exam_name, type: 'text'
      indexes :start_time, type: 'date'
      indexes :duration, type: 'integer'
    end
  end

  # rubocop:disable Metrics/MethodLength
  def self.search_by_exam_name(search_term)
    search_definition = {
      size: 20,
      query: {
        match_phrase_prefix: {
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
end
