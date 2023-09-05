# frozen_string_literal: true

# This is a class representing an controller
class LeaderboardController < ApplicationController
  def index
    @performances_summary = ExamPerformance.performances_summary(current_user)
    exam_averages_array = @performances_summary[:exam_averages].to_a
    @exam_averages = Kaminari.paginate_array(exam_averages_array).page(params[:page]).per(5)
  end

  def generate_report
    pdf = ExamReportGenerator.generate_report(Exam.find(params[:exam_id]))
    UserMailer.send_report(current_user, exam, pdf).deliver_later
    flash[:success] = 'Performance report generated and sent successfully!'
    redirect_to leaderboard_path
  end
end
