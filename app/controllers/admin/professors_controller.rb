# frozen_string_literal: true

# This is a sample class representing an Application controller
module Admin
  # class Admin::Admin::professorsController
  class ProfessorsController < ApplicationController
    before_action :authenticate_admin

    def new
      @professor = Professor.new
    end

    def index
      @professors = Professor.page(params[:page]).per(15)
    end

    def edit
      @professor = Professor.find(params[:id])
    end

    def update
      @professor = Professor.find(params[:id])

      if @professor.update(professor_params)
        redirect_to admin_professors_path, notice: 'Professor updated successfully.'
      else
        render :edit
      end
    end

    def create
      @professor = Professor.new(professor_params)
      if @professor.save
        redirect_to admin_professors_path, notice: 'Professor was successfully added.'
      else
        render :new
      end
    end

    def destroy
      @professor = Professor.find(params[:id])
      @professor.destroy

      redirect_to admin_professors_path, notice: 'Professor deleted successfully.'
    end

    private

    def professor_params
      params.require(:professor).permit(:name, :department_id, :summary, :linkedin_link, :profile_picture)
    end

    def authenticate_admin
      return if current_user&.admin?

      redirect_to root_path, alert: 'You are not authorized to perform this action.'
    end
  end
end
