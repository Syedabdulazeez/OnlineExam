# frozen_string_literal: true

# This is a class representing an model
class Department < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :subjects, dependent: :destroy
  has_many :exams, through: :subjects
  has_many :professors, dependent: :destroy

  validates :department_name, presence: true, length: { minimum: 3, message: 'must contain at least 3 letters' }

  scope :filtered_departments, lambda { |params|
    if params[:q].present?
      search_departments(params[:q])
    else
      all_departments
    end.page(params[:page]).per(params[:per_page])
  }

  scope :search_departments, lambda { |query|
    search(query).records
  }

  scope :all_departments, lambda {
    all
  }
end
