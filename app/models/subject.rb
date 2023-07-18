# frozen_string_literal: true

# This is a sample class representing an model
class Subject < ApplicationRecord
  has_many :exams

  validates :department_id, presence: true
  validates :subject_name, presence: { message: 'must be provided' },
                           length: { minimum: 3, message: 'must contain at least 3 letters' }
  belongs_to :department
  attr_accessor :name
end
