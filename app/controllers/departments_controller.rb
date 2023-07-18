# frozen_string_literal: true

# This is a sample class representing an controller
class DepartmentsController < ApplicationController
  def show
    @department = Department.find(params[:id])
    @subjects = @department.subjects
  end
end
