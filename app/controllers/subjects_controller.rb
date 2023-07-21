# frozen_string_literal: true

# This is a sample class representing an controller
class SubjectsController < ApplicationController
  def show
    @subject = Subject.find(params[:id])
    @exams = @subject.exams.includes(:registrations)
  rescue ActiveRecord::RecordNotFound
    redirect_to registrations_path, notice: 'Sorry recard not found !'
  end
end
