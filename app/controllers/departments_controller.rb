class DepartmentsController < ApplicationController
    def index
      @departments = Department.all
    end
  
    def show
      @department = Department.find(params[:id])
      # Fetch additional data about subjects (e.g., no. of past exams, no. of upcoming exams, etc.) and pass it to the view
    end
  end