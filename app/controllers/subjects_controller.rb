class SubjectsController < ApplicationController
    def index
      @subjects = Subject.all
    end
  
    def show
        @subject = Subject.find(params[:id])
        @exams = @subject.exams.includes(:registrations)
    end
  end