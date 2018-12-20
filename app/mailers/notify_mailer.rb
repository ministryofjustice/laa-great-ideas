# frozen_string_literal: true

class NotifyMailer < GovukNotifyRails::Mailer
  def email_template(user, template)
    set_template(template)
    mail(to: user.email)
  end

  def idea_email_template(user, idea, template)
    set_template(template)
    puts idea.title
    set_personalisation(
      title: idea.title
    )
    mail(to: user.email)
  end
end
