# frozen_string_literal: true

# This is a class representing an controller
class ExamPerformancesController < ApplicationController
  before_action :find_exam_performance, only: %i[show generate_report]

  def show; end

  def generate_report
    @exam_performance.generate_report
    flash[:success] = 'Performance report generated and sent successfully.'
    redirect_to leaderboard_index_path(@exam_performance.user)
  end

  private

  def find_exam_performance
    @exam_performance ||= ExamPerformance.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
