# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class SubjectsController < ApplicationController
    before_action :authenticate_admin
    before_action :find_subject, only: %i[edit update destroy]
    before_action :load_departments, only: %i[new create edit update]

    def index
      @subjects = Subject.page(params[:page]).per(12)
    end

    def new
      @subject = Subject.new
    end

    def create
      @subject = Subject.new(subject_params)
      if @subject.save
        redirect_to admin_subjects_path, notice: 'Subject was successfully created.'
      else
        render :new
      end
    end

    def edit; end

    def update
      if @subject.update(subject_params)
        redirect_to admin_subjects_path, notice: 'Subject was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @subject.destroy
      redirect_to admin_subjects_path, notice: 'Subject was successfully destroyed.'
    end

    private

    def find_subject
      @subject = Subject.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry record not found!'
    end

    def subject_params
      params.require(:subject).permit(:subject_name, :department_id)
    end

    def load_departments
      @departments = Department.all
    end
  end
end
