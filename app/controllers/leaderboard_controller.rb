# frozen_string_literal: true

# This is a class representing an controller
class LeaderboardController < ApplicationController
  def index
    @performances_summary = ExamPerformance.performances_summary(current_user)
    @overall_rank = ExamPerformance.overall_rank(current_user)
    @college_rank = ExamPerformance.college_rank(current_user)
  end

  def show
    @performance ||= ExamPerformance.find_by(user_id: params[:id])
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
