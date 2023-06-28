class UserMailer < ApplicationMailer
    def magic_link_email(user)
      @user = user
      @magic_link = magic_link_url(user.magic_link_token)
  
      mail(to: user.email, subject: "Magic Link Login")
    end

    def exam_reminder_email(user, exam, time_before)
      @user = user
      @exam = exam
      @time_before = time_before
  
      mail(to: @user.email, subject: "Exam Reminder - #{@exam.subject.subject_name}")
    end
    
    def send_report(user, exam, pdf)
      @user = user
      @exam = exam
  
      attachments["performance_report.pdf"] = pdf
  
      mail(to: @user.email, subject: "Performance Report - #{exam.exam_name}")
    end
    
    private
  
    def magic_link_url(token)
      url_for(controller: 'sessions', action: 'magic_link_login', token: token, host: 'localhost:3000')
    end
end
