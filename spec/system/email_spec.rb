# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Email', type: :system do
  describe 'Send an email' do
    let(:default_user) { build :user }
    it 'should send a template email' do
      template = '2561a8b1-244e-41cf-90ab-51dc27d08966'
      mail = NotifyMailer.email_template(default_user, template).deliver_now
      expect(mail.body).to have_text('This is a GOV.UK Notify email with template')
    end
  end

  describe 'Send an assigned idea email' do
    let(:admin_user) { build :admin }
    let(:idea) {build :idea }
    it 'should send an assigned idea email' do
      idea.assigned_user_id = admin_user.id
      template = '8c344764-890c-491c-9301-27cbd92a1c26'
      mail = NotifyMailer.idea_email_template(admin_user, idea, template).deliver_now
      expect(mail.body).to have_text('This is a GOV.UK Notify email with template')
      expect(mail.body).to have_text(template)
      expect(mail.body).to have_text(idea.title)
    end
  end
end
