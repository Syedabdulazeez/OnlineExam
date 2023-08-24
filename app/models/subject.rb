# frozen_string_literal: true

# This is a class representing an model
class Subject < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :exams, dependent: :destroy
  belongs_to :department

  validates :department_id, presence: { message: 'Please select subject' }
  validates :subject_name, presence: { message: "con't be blank" },
                           length: { minimum: 3, message: 'must contain at least 3 letters' }
  attr_accessor :name
end
