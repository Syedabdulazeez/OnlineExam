# frozen_string_literal: true

# This is a class representing an mailer
class ApplicationMailer < ActionMailer::Base
  default from: 'syed.abdulazeez@kreeti.com'
  layout 'mailer'
end
