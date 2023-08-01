# frozen_string_literal: true

# This is a class representing an controller
class RegistrationsController < ApplicationController
  include RegistrationsHelper

  def index
    if logged_in?
      @search_term = params[:search]
      @department_options = Department.all
      @subject_options = subject_options(params[:department])
      exams = filter_and_sort_exams(Exam.all, params)
      @exams = exams.page(params[:page]).per(20)
    else
      redirect_to root_path
    end
  end

  def new
    @exam = Exam.find(params[:exam_id])
    @disable_links = Time.current >= @exam.start_time
  end

  def create
    @exam = Exam.find(params[:exam_id])
    @registration = Registration.new(registration_params)
    @registration.exam = @exam
    @registration.user = current_user
    if save_registration_and_send_emails
      redirect_to root_path, notice: 'Successfully registered!'
    else
      render :new
    end
  end

  private

  def registration_params
    params.permit(:exam_id)
  end

  def exam_params
    params.required(:Exam).permit(:username, :email, :password, :college, :department)
  end
end
