# frozen_string_literal: true

# This is a sample class representing an mailer
class RegistrationMailer < ApplicationMailer
  def confirmation_email(registration)
    @registration = registration
    mail(to: @registration.user.email, subject: 'Exam Registration Confirmation')
  end
end
