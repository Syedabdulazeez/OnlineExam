# app/mailers/registration_mailer.rb
class RegistrationMailer < ApplicationMailer
    def confirmation_email(registration)
      @registration = registration
      mail(to: @registration.user.email, subject: 'Exam Registration Confirmation')
    end
  end
  