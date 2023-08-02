# frozen_string_literal: true

# This is a class representing an controller
class DepartmentsController < ApplicationController
  def show
    @department ||= Department.find_by(id: params[:id])
    if @department.nil? || @department.subjects.empty?
      flash[:danger] = 'Sorry recard not found !'
      redirect_to registrations_path
    else
      @subjects ||= @department.subjects
    end
  end
end
