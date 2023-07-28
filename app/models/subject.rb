# frozen_string_literal: true

# This is a class representing an model
class Subject < ApplicationRecord
  has_many :exams, dependent: :destroy

  validates :department_id, presence: { message: 'Please select subject' }
  validates :subject_name, presence: { message: "con't be blank" },
                           length: { minimum: 3, message: 'must contain at least 3 letters' }
  belongs_to :department
  attr_accessor :name
end
