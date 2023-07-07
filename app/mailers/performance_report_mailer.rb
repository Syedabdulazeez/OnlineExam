# app/mailers/performance_report_mailer.rb
class PerformanceReportMailer < ApplicationMailer
  def send_report(exam_performance, pdf)
    @exam_performance = exam_performance
    attachments["performance_report.pdf"] = pdf.read

    mail(to: @exam_performance.user.email, subject: "Performance Report")
  end
end
# app/mailers/performance_report_mailer.rb
# class PerformanceReportMailer < ApplicationMailer
#   def send_report(recipient_email, pdf)
#     attachments["performance_report.pdf"] = pdf

#     mail(to: recipient_email, subject: "Performance Report")
#   end
# end
