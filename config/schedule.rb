# frozen_string_literal: true

# This is a shedule
set :output, 'log/cron.log'

every 1.day, at: '9:00 am' do
  runner 'ExamReminderJob.send_reminders'
end
