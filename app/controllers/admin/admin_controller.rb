# frozen_string_literal: true

# class Admin::AdminController
module Admin
  # class Admin::AdminController
  class AdminController < ApplicationController
    before_action :require_admin

    def require_admin
      return if current_user.admin?

      redirect_to root_path, alert: 'You are not authorized to access this page.'
    end
  end
end
