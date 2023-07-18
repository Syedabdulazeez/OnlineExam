# frozen_string_literal: true

# This is a sample class representing an controller
class ExamPerformancesController < ApplicationController
  def show
    @exam_performance = ExamPerformance.find(params[:id])
  end

  def generate_report
    @exam_performance = ExamPerformance.find(params[:id])
    @exam_performance.generate_report
    flash[:notice] = 'Performance report generated and sent successfully.'
    redirect_to leaderboard_index_path(@exam_performance.user)
  end
end
