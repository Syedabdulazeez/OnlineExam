# frozen_string_literal: true

module Admin
  # class Admin::Admin::DepartmentsController
  class DepartmentsController < Admin::AdminController
    before_action :authenticate_admin
    before_action :find_department, only: %i[edit update destroy]

    def index
      @departments = Department.filtered_departments(params)
    end

    def new
      @department = Department.new
    end

    def create
      @department = Department.new(department_params)
      if @department.save
        flash[:success] = 'Department created successfully.'
        redirect_to admin_departments_path
      else
        render :new
      end
    end

    def destroy
      return unless @department.destroy

      flash[:danger] = 'Department was successfully destroyed.'
      redirect_to admin_departments_path
    end

    def edit; end

    def update
      if @department.update(department_params)
        flash[:success] = 'Department was successfully updated.'
        redirect_to admin_departments_path
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
    end
  end
end
