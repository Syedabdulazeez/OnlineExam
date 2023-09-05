# frozen_string_literal: true

# This is a class representing an controller
class ExamsController < ApplicationController
  before_action :find_exam, only: %i[conduct demo_exam show submit_exam]

  def conduct
    current_user.mark_exam_in_progress(@exam)
  end

  def demo_exam; end

  def show; end

  def submit_exam
    user_answers = params[:user_answers]
    redirect_to_exam_performance(user_answers)
    current_user.clear_exam_in_progress(@exam)
  end

  private

  def find_exam
    @exam = Exam.find(params[:id])
  end

  def handle_no_user_answers
    flash[:danger] = 'Please select answers for all questions.'
    redirect_to conduct_exam_path(exam_id: @exam.id)
  end

  def redirect_to_exam_performance(user_answers)
    percentage_score = @exam.calculate_score(user_answers)
    exam_performance = @exam.create_exam_performance(current_user.id, percentage_score)
    redirect_to exam_performance_path(exam_performance)
  end
end
