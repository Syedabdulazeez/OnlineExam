# frozen_string_literal: true

# This is a class representing an model
class Question < ApplicationRecord
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  belongs_to :exam

  validates :exam_id, presence: { message: 'plese select exam' }
  validates :question_text, presence: true, length: { minimum: 5, message: 'must contain at least 5 letters' }
  validates :answer1, presence: true
  validates :answer2, presence: true
  validates :answer3, presence: true
  validates :answer4, presence: true
  validates :correct_answer, presence: { message: 'plese select option' }

  scope :filtered_questions, lambda { |params|
    initial_questions(params[:q])
      .filter_by_exam(params[:exam_id])
      .paginate_questions(params[:page], params[:per_page])
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
