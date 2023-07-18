# frozen_string_literal: true

namespace :exam_reminder do
  desc 'Send exam reminders'
  task send_reminders: :environment do
    Exam.all.each do |exam|
      ExamReminderJob.perform_later(exam.id)
    end
  end
end
