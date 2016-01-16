config = Rails.application.config
mail_config = config.x.mail

case mail_config[:delivery_method]
when :smtp
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = mail_config[:smtp_settings] if mail_config[:smtp_settings].present?
when :sendmail
  config.action_mailer.delivery_method = :sendmail
  config.action_mailer.sendmail_settings = mail_config[:sendmail_settings] if mail_config[:sendmail_settings].present?
else
  config.action_mailer.delivery_method = :test
end
