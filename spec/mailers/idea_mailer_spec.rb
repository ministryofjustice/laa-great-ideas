# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IdeaMailer, type: :mailer do
  describe 'Assigned Idea Email' do
    let(:admin_user) { build :admin }
    let(:idea) { build :idea, title: 'New idea', assigned_user_id: admin_user.id }
    let(:template) { '8c344764-890c-491c-9301-27cbd92a1c26' }
    let(:mail) { described_class.assigned_idea_email_template(admin_user, idea) }

    it 'is a govuk_notify delivery' do
      expect(mail.delivery_method).to be_a(GovukNotifyRails::Delivery)
    end

    it 'sets the body' do
      expect(mail.body).to match("This is a GOV.UK Notify email with template #{template}")
      expect(mail.body).to have_text(idea.title)
    end

    it 'sets the template' do
      expect(mail.govuk_notify_template).to eq(template)
    end
  end
end
