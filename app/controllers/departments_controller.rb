# frozen_string_literal: true

# This is a class representing an controller
class DepartmentsController < ApplicationController
  def show
    @department ||= Department.find_by(id: params[:id])
    if @department.nil? || @department.subjects.empty?
      render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
    else
      @subjects ||= @department.subjects
    end
  end
end
