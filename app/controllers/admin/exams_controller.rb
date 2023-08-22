# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class ExamsController < ApplicationController
    include RegistrationsHelper
    before_action :authenticate_admin
    before_action :find_exam, only: %i[show edit update destroy]
    before_action :load_subjects, only: %i[new create edit update]

    def index
      @search_term = params[:search]
      @department_options = Department.all
      @subject_options = subject_options(params[:department])
      exams = filter_and_sort_exams(Exam.all, params)
      @exams = exams.page(params[:page]).per(12)
    end

    def show; end

    def edit
      @exam_type_options = ['Demo Exam', 'Actual Exam']
      @selected_exam_type = @exam.is_demo? ? 'Demo Exam' : 'Actual Exam'
    end

    def update
      if @exam.update(exam_params)
        flash[:success] = 'Exam was successfully updated.'
        redirect_to admin_exams_path
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
        flash[:success] = 'Exam was successfully created.'
        redirect_to admin_exams_path
      else
        render :new
      end
    end

    def destroy
      @exam.destroy
      flash[:danger] = 'Exam was successfully destroyed.'
      redirect_to admin_exams_path
    end

    private

    def exam_params
      params.require(:exam).permit(:exam_name, :duration, :subject_id, :is_demo, :start_time)
    end

    def find_exam
      @exam = Exam.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end

    def load_subjects
      @subjects = Subject.all
    end
  end
end
