# frozen_string_literal: true

# This is a class representing an controller
class ExamsController < ApplicationController
  before_action :find_exam, only: %i[conduct demo_exam show submit_exam]

  def conduct
    current_user.mark_exam_in_progress(@exam)
    @questions = @exam.shuffled_questions
  end

  def demo_exam
    @demo_exam ||= @exam.demo_exam
  end

  def show
    @department ||= @exam.subject.department
    @questions ||= @exam.shuffled_questions
  rescue ActiveRecord::RecordNotFound
    redirect_to registrations_path, flash[:danger] = 'Sorry record not found!'
  end

  def submit_exam
    user_answers = params[:user_answers]
    if user_answers.present?
      redirect_to_exam_performance(user_answers)
    else
      handle_no_user_answers
    end
    current_user.clear_exam_in_progress(@exam)
  end

  private

  def find_exam
    @exam = Exam.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Sorry record not found!'
    redirect_to registrations_path
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
