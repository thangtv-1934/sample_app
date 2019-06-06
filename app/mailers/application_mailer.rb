class ApplicationMailer < ActionMailer::Base
  default from: Settings.email.mail_send
  layout "mailer"
end
