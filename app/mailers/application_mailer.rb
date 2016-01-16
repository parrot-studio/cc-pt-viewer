class ApplicationMailer < ActionMailer::Base
  default from: ServerSettings.mail_from
  layout 'mailer'
end
