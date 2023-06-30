# app/controllers/exam_performances_controller.rb
class ExamPerformancesController < ApplicationController
  def show
    @exam_performance = ExamPerformance.find(params[:id])
  end
end
