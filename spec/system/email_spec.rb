# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Email', type: :system do
  describe 'Send an email' do
    let(:default_user) { build :user }
    it 'should send a template email' do
      template = '2561a8b1-244e-41cf-90ab-51dc27d08966'
      mail = NotifyMailer.email_template(default_user).deliver_now
      expect(mail.body).to have_text('This is a GOV.UK Notify email with template')
      expect(mail.body).to have_text(template)
    end
  end
end
