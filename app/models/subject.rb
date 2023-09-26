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

  scope :filtered_subjects, lambda { |query, exam_id, page, per_page|
    initial_questions(query)
      .filter_by_exam(exam_id)
      .paginate_questions(page, per_page)
  }

  scope :initial_questions, lambda { |query|
    if query.present?
      search(query).records
    else
      all
    end
  }

  scope :filter_by_exam, lambda { |exam_id|
    if exam_id.present?
      where(exam_id:)
    else
      all
    end
  }

  scope :paginate_questions, lambda { |page, per_page|
    page(page).per(per_page)
  }
end
