# frozen_string_literal: true

class DeviseCustomMailer < Devise::Mailer
  helper :application # gives access to all helpers defined within `application_helper`.
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  # default template_path: 'devise/mailer' # to make sure that your mailer uses the devise views

  def confirmation_instructions(record, token, _opts = {})
    url = confirmation_url(record, confirmation_token: token)
    set_template('04e87e44-5fcf-4cc2-b7b8-776beb6da4e5')
    set_personalisation(
      token_url: url
    )
    mail(to: record.email)
  end
end
