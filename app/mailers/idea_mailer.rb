# frozen_string_literal: true

class IdeaMailer < GovukNotifyRails::Mailer
  def assigned_idea_email_template(user, idea)
    template = '8c344764-890c-491c-9301-27cbd92a1c26'
    set_template(template)
    set_personalisation(title: idea.title)
    mail(to: user.email)
  end
end
