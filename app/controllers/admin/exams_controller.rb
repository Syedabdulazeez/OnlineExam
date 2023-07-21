# frozen_string_literal: true

# This is a sample class representing an Application controller
module Admin
  # class Admin::Admin::DepartmentsController
  class ExamsController < ApplicationController
    before_action :authenticate_admin

    def index
      @exams = Exam.page(params[:page]).per(12)
    end

    def show
      @exam = Exam.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry recard not found !'
    end

    def edit
      @exam = Exam.find(params[:id])
      @subjects = Subject.all
      @exam_type_options = ['Demo Exam', 'Actual Exam']
      @selected_exam_type = @exam.is_demo? ? 'Demo Exam' : 'Actual Exam'
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry recard not found !'
    end

    def update
      @exam = Exam.find(params[:id])
      @subjects = Subject.all
      if @exam.update(exam_params)
        redirect_to admin_exams_path, notice: 'Subject was successfully updated.'
      else
        @exams = Exam.all
        render :edit
      end
    end

    def new
      @exam = Exam.new
      @subjects = Subject.all
    end

    def create
      @exam = Exam.new(exam_params)
      if @exam.save
        redirect_to admin_exams_path, notice: 'Exam was successfully created.'
      else
        @subjects = Subject.all
        render :new
      end
    end

    def destroy
      @exam = Exam.find(params[:id])
      @exam.destroy
      redirect_to admin_exams_path, notice: 'Exam was successfully destroyed.'
    end

    private

    def exam_params
      start_time = DateTime.parse(params[:exam][:start_time])
      adjusted_start_time = start_time - 5.hours - 30.minutes
      params.require(:exam).permit(:exam_name, :duration, :subject_id, :is_demo).merge(start_time: adjusted_start_time)
    end

    def authenticate_admin
      return if current_user&.admin?

      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
