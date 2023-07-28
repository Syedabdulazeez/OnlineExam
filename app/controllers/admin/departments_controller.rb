# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class DepartmentsController < Admin::AdminController
    before_action :authenticate_admin
    before_action :find_department, only: %i[edit update destroy]

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
      return unless @department.destroy

      redirect_to admin_departments_path, notice: 'Department was successfully destroyed.'
    end

    def edit; end

    def update
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

    def find_department
      @department = Department.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry record not found!'
    end
  end
end
