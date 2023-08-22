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
        flash[:success] = 'Professor updated successfully.'
        redirect_to admin_professors_path
      else
        render :edit
      end
    end

    def create
      @professor = Professor.new(professor_params)
      if @professor.save
        flash[:success] = 'Professor was successfully added.'
        redirect_to admin_professors_path
      else
        render :new
      end
    end

    def destroy
      @professor.destroy
      flash[:success] = 'Professor deleted successfully.'
      redirect_to admin_professors_path
    end

    private

    def find_professor
      @professor = Professor.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    end

    def professor_params
      params.require(:professor).permit(:name, :department_id, :summary, :linkedin_link, :profile_picture)
    end
  end
end
