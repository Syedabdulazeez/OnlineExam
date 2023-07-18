# frozen_string_literal: true

# This is a sample class representing an model
class Department < ApplicationRecord
  has_many :subjects
  has_many :exams, through: :subjects
  has_many :professors

  validates :department_name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }
end
