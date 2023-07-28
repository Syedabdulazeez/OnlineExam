# frozen_string_literal: true

module Admin
  # class Admin::Admin::professorsController
  class ProfessorsController < ApplicationController
    before_action :authenticate_admin
    before_action :find_professor, only: %i[edit update destroy]

    def new
      @professor = Professor.new
    end

    def index
      @professors = Professor.page(params[:page]).per(15)
    end

    def edit; end

    def update
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
      @professor.destroy
      redirect_to admin_professors_path, notice: 'Professor deleted successfully.'
    end

    private

    def find_professor
      @professor = Professor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_root_path, notice: 'Sorry record not found!'
    end

    def professor_params
      params.require(:professor).permit(:name, :department_id, :summary, :linkedin_link, :profile_picture)
    end
  end
end
