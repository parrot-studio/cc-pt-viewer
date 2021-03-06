class AdminMailer < ApplicationMailer
  def test_mail
    mail(to: admin_to, subject: 'test mail')
  end

  def request_mail(content, ip: nil, time: nil)
    subject = "[ccpts] user's request"
    @ip = ip
    @time = (time || Time.current)
    @content = content
    mail(to: admin_to, subject: subject)
  end

  private

  def admin_to
    ServerSettings.mail_admin_to
  end
end
