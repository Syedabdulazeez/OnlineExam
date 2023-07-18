# frozen_string_literal: true

# This is a sample class representing an mailer
class PerformanceReportMailer < ApplicationMailer
  def send_report(exam_performance, pdf)
    @exam_performance = exam_performance
    attachments['performance_report.pdf'] = pdf.read

    mail(to: @exam_performance.user.email, subject: 'Performance Report')
  end
end
