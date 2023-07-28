# frozen_string_literal: true

# This is a class representing an job
class ExamReminderJob < ApplicationJob
  queue_as :default

  def perform(exam_id, time_before)
    exam = Exam.find_by_id(exam_id)
    send_reminder_emails(exam, time_before)
  end

  private

  def send_reminder_emails(exam, time_before)
    exam.users.each do |user|
      UserMailer.exam_reminder_email(user, exam, time_before).deliver_now
    end
  end
end
