# frozen_string_literal: true

# This is a class representing an controller
class SubjectsController < ApplicationController
  def show
    @subject ||= Subject.find(params[:id])
    @exams ||= @subject.exams.includes(:registrations)
  rescue ActiveRecord::RecordNotFound
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end
end
