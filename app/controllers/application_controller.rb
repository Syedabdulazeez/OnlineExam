# frozen_string_literal: true

# This is a representing an controller
class ApplicationController < ActionController::Base
  include ApplicationHelper
  protect_from_forgery with: :null_session

  helper_method :current_user

  rescue_from ActiveRecord::RecordNotFound, with: :not_found_method

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def authenticate_admin
    return if current_user&.admin?

    flash[:danger] = 'You are not authorized to perform this action.'
    redirect_to root_path
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user
  end

  def dashboard
    if !logged_in?
      redirect_to login_path
    elsif current_user.admin
      redirect_to admin_root_path
    else
      @exams = upcoming_exams(current_user, 15)
    end
  end
end
