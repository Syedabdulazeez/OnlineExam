set :output, 'log/cron.log'

every 1.day, at: '9:00 am' do
  runner 'ExamReminderJob.send_reminders'
end
