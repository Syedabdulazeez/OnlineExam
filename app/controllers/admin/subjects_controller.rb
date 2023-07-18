# frozen_string_literal: true

# This is a sample class representing an Application controller
module Admin
  # class Admin::Admin::DepartmentsController
  class SubjectsController < ApplicationController
    before_action :authenticate_admin
    def index
      @subjects = Subject.page(params[:page]).per(12)
    end

    def new
      @subject = Subject.new
      @departments = Department.all
    end

    def create
      @subject = Subject.new(subject_params)
      if @subject.save
        redirect_to admin_subjects_path, notice: 'Subject was successfully created.'
      else
        @departments = Department.all
        render :new
      end
    end

    def edit
      @subject = Subject.find(params[:id])
      @departments = Department.all
    end

    def update
      @subject = Subject.find(params[:id])
      if @subject.update(subject_params)
        redirect_to admin_subjects_path, notice: 'Subject was successfully updated.'
      else
        @departments = Department.all
        render :edit
      end
    end

    def destroy
      @subject = Subject.find(params[:id])
      @subject.destroy
      redirect_to admin_subjects_path, notice: 'Subject was successfully destroyed.'
    end

    private

    def subject_params
      params.require(:subject).permit(:subject_name, :department_id)
    end

    def authenticate_admin
      return if current_user&.admin?

      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
