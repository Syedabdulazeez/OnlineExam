# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class ExamsController < ApplicationController
    before_action :authenticate_admin
    before_action :find_exam, only: %i[show edit update destroy]
    before_action :load_subjects, only: %i[new create edit update]

    def index
      @exams = Exam.page(params[:page]).per(12)
    end

    def show; end

    def edit
      @exam_type_options = ['Demo Exam', 'Actual Exam']
      @selected_exam_type = @exam.is_demo? ? 'Demo Exam' : 'Actual Exam'
    end

    def update
      if @exam.update(exam_params)
        redirect_to admin_exams_path, notice: 'Exam was successfully updated.'
      else
        render :edit
      end
    end

    def new
      @exam = Exam.new
    end

    def create
      @exam = Exam.new(exam_params)
      if @exam.save
        redirect_to admin_exams_path, notice: 'Exam was successfully created.'
      else
        render :new
      end
    end

    def destroy
      @exam.destroy
      redirect_to admin_exams_path, notice: 'Exam was successfully destroyed.'
    end

    private

    def exam_params
      start_time_str = params[:exam][:start_time]
      start_time = start_time_str.present? ? DateTime.parse(start_time_str) : nil
      adjusted_start_time = (start_time - 5.hours - 30.minutes if start_time)

      params.require(:exam).permit(:exam_name, :duration, :subject_id, :is_demo).merge(start_time: adjusted_start_time)
    end

    def find_exam
      @exam = Exam.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry record not found!'
    end

    def load_subjects
      @subjects = Subject.all
    end
  end
end
