config = Rails.application.config

case Settings.mail.delivery_method.to_sym
when :smtp
  config.action_mailer.delivery_method = :smtp
  conf = (Settings.mail.smtp_settings || {}).deep_symbolize_keys
  config.action_mailer.smtp_settings = conf if conf.present?
when :sendmail
  config.action_mailer.delivery_method = :sendmail
  conf = (Settings.mail.sendmail_settings || {}).deep_symbolize_keys
  config.action_mailer.sendmail_settings = conf if conf.present?
else
  config.action_mailer.delivery_method = :test
end
