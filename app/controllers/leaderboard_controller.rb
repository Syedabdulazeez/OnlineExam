# frozen_string_literal: true

# This is a class representing an controller
class LeaderboardController < ApplicationController
  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
  def index
    @user = current_user
    @exam_ids_attended = ExamPerformance.exam_ids_attended(@user)
    @exam_averages = ExamPerformance.exam_averages(@exam_ids_attended)
    @highest_marks = ExamPerformance.highest_marks(@exam_ids_attended)
    @exam_performances = ExamPerformance.where(exam_id: @exam_ids_attended)
    @subject_performances = ExamPerformance.subject_performances(@user)
    @subject_performance_hash = ExamPerformance.subject_performance_hash(@subject_performances)
    @department_performances = ExamPerformance.department_performances(@user)
    @department_performance_hash = ExamPerformance.department_performance_hash(@department_performances)
    @overall_rank = ExamPerformance.overall_rank(@user)
    @college_rank = @user.college.present? ? ExamPerformance.college_rank(@user) : nil
  end
  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

  def show
    @performance = ExamPerformance.find_by(user_id: params[:id])
    @subject = @performance.exam.subject
  end

  def generate_report
    exam = Exam.find(params[:exam_id])
    pdf = ExamReportGenerator.generate_report(exam)
    UserMailer.send_report(current_user, exam, pdf).deliver_later
    flash[:notice] = 'Performance report generated and sent successfully!'
    redirect_to leaderboard_path
  end
end
