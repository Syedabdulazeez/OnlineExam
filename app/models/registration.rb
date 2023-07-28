# frozen_string_literal: true

# This is a class representing an model
class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :exam

  validates :exam_id, uniqueness: { scope: :user_id, message: 'has alredy been registered' }

  def started?
    in_progress?
  end

  def completed?
    exam_performance = ExamPerformance.find_by(user_id:, exam_id:)
    exam_performance.present? && exam_performance.marks_obtained.present?
  end
end
