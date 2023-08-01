# frozen_string_literal: true

module Admin
  # class Admin::AdminController
  class AdminController < ApplicationController
    before_action :require_admin

    def require_admin
      return if current_user&.admin?

      redirect_to root_path, notice: 'You are not authorized to access this page.'
    end
  end
end
