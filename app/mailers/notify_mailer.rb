# frozen_string_literal: true

class NotifyMailer < GovukNotifyRails::Mailer
  def email_template(user)
    template = '2561a8b1-244e-41cf-90ab-51dc27d08966'
    set_template(template)
    mail(to: user.email)
  end
end
