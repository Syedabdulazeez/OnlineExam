# frozen_string_literal: true

# This is a class representing an model
class Department < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :subjects, dependent: :destroy
  has_many :exams, through: :subjects
  has_many :professors, dependent: :destroy

  validates :department_name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }
end
