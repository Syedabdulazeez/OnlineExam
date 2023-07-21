# frozen_string_literal: true

# This is a sample class representing an controller
class ExamsController < ApplicationController
  def show
    @exam = Exam.find(params[:id])
    @questions = @exam.shuffled_questions
    @department = @exam.subject.department
  rescue ActiveRecord::RecordNotFound
    redirect_to registrations_path, notice: 'Sorry recard not found !'
  end

  def conduct
    @exam = Exam.find(params[:id])
    current_user.mark_exam_in_progress(@exam)
    @questions = @exam.shuffled_questions
  end

  def demo_exam
    @actual_exam = Exam.find(params[:id])
    @demo_exam = @actual_exam.demo_exam
  end

  def submit_exam
    exam = Exam.find(params[:id])
    user_answers = params[:user_answers]
    if user_answers.present?
      redirect_to_exam_performance(exam, user_answers)
    else
      handle_no_user_answers(exam)
    end
    current_user.clear_exam_in_progress(exam)
  end

  private

  def redirect_to_exam_performance(exam, user_answers)
    percentage_score = exam.calculate_score(user_answers)
    exam_performance = exam.create_exam_performance(current_user.id, percentage_score)
    redirect_to exam_performance_path(exam_performance)
  end

  def handle_no_user_answers(exam)
    flash[:error] = 'Please select answers for all questions.'
    redirect_to exam_path(exam_id: exam.id)
  end
end
