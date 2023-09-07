# frozen_string_literal: true

# This is a class representing an controller
class RegistrationsController < ApplicationController
  include RegistrationsHelper

  before_action :set_exam, only: %i[create new]
  before_action :require_user

  def index
    if logged_in?
      @exams = filter_and_sort_exams(Exam.all, params).page(params[:page]).per(20)
    else
      redirect_to root_path
    end
  end

  def new
    @disable_links = Time.current >= @exam.start_time
  end

  def create
    @registration = Registration.new(registration_params)
    @registration.exam = @exam
    @registration.user = current_user
    if save_registration_and_send_emails
      flash[:success] = 'Successfully registered!'
      redirect_to root_path
    else
      redirect_to registrations_url
    end
  end

  private

  def set_exam
    @exam = Exam.find(params[:exam_id])
  end

  def registration_params
    params.permit(:exam_id)
  end

  def exam_params
    params.required(:Exam).permit(:username, :email, :password, :college, :department)
  end
end
