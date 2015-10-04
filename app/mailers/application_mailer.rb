class ApplicationMailer < ActionMailer::Base
  default from: MailSettings.from
  layout 'mailer'
end
