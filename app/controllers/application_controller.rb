# frozen_string_literal: true

# This is a sample class representing an controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include ApplicationHelper

  def dashboard
    if !logged_in?
      redirect_to login_path, alert: 'Incorrect username or password.'
    elsif current_user.admin
      redirect_to admin_root_path
    else
      @user = current_user
      @exams = upcoming_exams(current_user, 10)
    end
  end
end
