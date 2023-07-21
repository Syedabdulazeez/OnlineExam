# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class DepartmentsController < Admin::AdminController
    before_action :authenticate_admin

    def index
      @departments = Department.page(params[:page]).per(12)
    end

    def new
      @department = Department.new
    end

    def create
      @department = Department.new(department_params)
      if @department.save
        redirect_to admin_departments_path, notice: 'Department created successfully.'
      else
        render :new
      end
    end

    def destroy
      @department = Department.find(params[:id])
      @department.destroy
      redirect_to admin_departments_path, notice: 'Department was successfully destroyed.'
    end

    def edit
      @department = Department.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry recard not found !'
    end

    def update
      @department = Department.find(params[:id])
      if @department.update(department_params)
        redirect_to admin_departments_path, notice: 'Department was successfully updated.'
      else
        render :edit
      end
    end

    private

    def department_params
      params.require(:department).permit(:department_name)
    end

    def authenticate_admin
      return if current_user&.admin?

      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
