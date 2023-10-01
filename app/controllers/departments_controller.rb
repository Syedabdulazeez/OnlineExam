# frozen_string_literal: true

# This is a class representing an controller
class DepartmentsController < ApplicationController
  before_action :require_user

  def show
    @department = Department.find(params[:id])
  end
end
