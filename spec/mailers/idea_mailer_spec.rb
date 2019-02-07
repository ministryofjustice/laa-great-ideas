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

    it 'sets the recipient' do
      expect(mail.to).to eq([admin_user.email])
    end

    it 'sets the body' do
      expect(mail.body).to match("This is a GOV.UK Notify email with template #{template}")
      expect(mail.body).to have_text(idea.title)
    end

    it 'sets the template' do
      expect(mail.govuk_notify_template).to eq(template)
    end
  end

  describe 'Status Update Email' do
    let(:user) { build :user }
    let(:idea) { build :idea, title: 'New idea', user_id: user.id }
    let(:template) { 'd816f609-bc00-4f79-961c-da93ffdb8471' }
    let(:mail) { described_class.status_change_email_template(user, idea) }

    it 'is a govuk_notify delivery' do
      expect(mail.delivery_method).to be_a(GovukNotifyRails::Delivery)
    end

    it 'sets the recipient' do
      expect(mail.to).to eq([user.email])
    end

    it 'sets the body' do
      expect(mail.body).to match("This is a GOV.UK Notify email with template #{template}")
      expect(mail.body).to have_text(idea.title)
      expect(mail.body).to have_text(idea.status)
    end

    it 'sets the template' do
      expect(mail.govuk_notify_template).to eq(template)
    end
  end
end
