# frozen_string_literal: true

# This is a class representing an model
class User < ApplicationRecord
  has_secure_password
  has_many :exam_performances
  has_many :registrations
  has_many :exams, through: :registrations

  validates :username, presence: true, length: { minimum: 3 }, uniqueness: true
  validates :email, presence: true, uniqueness: true,
                    format: { with: /\A[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]+\z/, message: 'must be a valid email address' }

  def generate_magic_link_token
    self.magic_link_token = SecureRandom.urlsafe_base64
    save(validate: false)
  end

  def exam_registered?(exam)
    registrations.exists?(exam_id: exam.id)
  end

  def exam_in_progress?(exam)
    registration = registrations.find_by(exam_id: exam.id)
    registration.in_progress?
  end

  def mark_exam_in_progress(exam)
    registration = registrations.find_by(exam_id: exam.id)
    registration.update(in_progress: true)
  end

  def clear_exam_in_progress(exam)
    registrations.find_by(exam_id: exam.id).update(in_progress: false)
  end

  def exam_started?(exam, user)
    registration = registrations.find_by(exam_id: exam.id, user_id: user.id)
    registration.present? && registration.started?
  end

  def department_performances
    exam_performances.joins(exam: :subject)
                     .group('subjects.department_id')
                     .average(:marks_obtained)
                     .map do |performance_id, average_score|
      department = Department.find_by(id: performance_id)
      department_name = department ? department.department_name : 'Department not found'

      [department_name, average_score]
    end.to_h
  end

  def overall_rank
    exam_performances.where(exam_id: Exam.all.pluck(:id))
                     .group(:user_id)
                     .order('SUM(marks_obtained) DESC')
                     .pluck(:user_id)
                     .index(id)
  end

  def college_rank
    return unless college.present?

    exam_performances.joins(user: { registrations: :exam })
                     .joins(exam: { subject: :department })
                     .where(users: { college: })
                     .group(:user_id)
                     .order('SUM(marks_obtained) DESC')
                     .pluck(:user_id)
                     .index(id)
  end
end
