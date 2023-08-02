# frozen_string_literal: true

# This is a class representing an controller
class SubjectsController < ApplicationController
  def show
    @subject ||= Subject.find(params[:id])
    @exams ||= @subject.exams.includes(:registrations)
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = 'Sorry recard not found !'
    redirect_to registrations_path
  end
end
