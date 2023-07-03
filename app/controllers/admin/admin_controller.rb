class Admin::AdminController < ApplicationController
  before_action :require_admin

  def index
    # Add any logic or instance variables needed for the admin dashboard
  end

  private

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
