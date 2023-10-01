# frozen_string_literal: true

module Admin
  # class Admin::AdminController
  class AdminController < ApplicationController
    before_action :require_admin

    def index; end

    private

    def require_admin
      return if current_user&.admin?

      flash[:danger] = 'You are not authorized to access this page.'
      redirect_to root_path
    end
  end
end
