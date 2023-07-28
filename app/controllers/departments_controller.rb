# frozen_string_literal: true

# This is a class representing an controller
class DepartmentsController < ApplicationController
  def show
    @department = Department.find_by(id: params[:id])
    if @department.nil? || @department.subjects.empty?
      redirect_to registrations_path, notice: 'Sorry recard not found !'
    else
      @subjects = @department.subjects
    end
  end
end
