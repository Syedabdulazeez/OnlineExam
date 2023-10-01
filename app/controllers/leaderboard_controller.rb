# frozen_string_literal: true

# This is a class representing an controller
class LeaderboardController < ApplicationController
  before_action :require_user

  def index
    @performances_summary = ExamPerformance.performances_summary(current_user)
    exam_averages_array = @performances_summary[:exam_averages].to_a
    @exam_averages = Kaminari.paginate_array(exam_averages_array).page(params[:page]).per(5)
  end
end
