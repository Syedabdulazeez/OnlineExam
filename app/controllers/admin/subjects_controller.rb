# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class SubjectsController < ApplicationController
    before_action :authenticate_admin
    before_action :find_subject, only: %i[edit update destroy]
    before_action :load_departments, only: %i[new create edit update]

    def index
      params[:per_page] ||= 15
      @subjects = Subject.filtered_subjects(params[:q], params[:exam_id], params[:page], params[:per_page])
    end

    def new
      @subject = Subject.new
    end

    def create
      @subject = Subject.new(subject_params)
      if @subject.save
        flash[:success] = 'Subject was successfully created.'
        redirect_to admin_subjects_path
      else
        render :new
      end
    end

    def edit; end

    def update
      if @subject.update(subject_params)
        flash[:success] = 'Subject was successfully updated.'
        redirect_to admin_subjects_path
      else
        render :edit
      end
    end

    def destroy
      @subject.destroy
      flash[:danger] = 'Subject was successfully destroyed.'
      redirect_to admin_subjects_path
    end

    private

    def find_subject
      @subject = Subject.find(params[:id])
    end

    def subject_params
      params.require(:subject).permit(:subject_name, :department_id)
    end

    def load_departments
      @departments = Department.all
    end
  end
end
