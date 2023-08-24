# frozen_string_literal: true

module Admin
  # This is a class representing an helper
  module QuestionsHelper
    def filtered_questions
      questions = initial_questions
      questions = filter_by_exam(questions)
      paginate_questions(questions)
    end

    private

    def initial_questions
      if params[:q].present?
        Question.search(params[:q]).records
      else
        Question.all
      end
    end

    def filter_by_exam(questions)
      if params[:exam_id].present?
        questions.where(exam_id: params[:exam_id])
      else
        questions
      end
    end

    def paginate_questions(questions)
      questions.page(params[:page]).per(params[:per_page])
    end
  end
end
