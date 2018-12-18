# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'me@justice.gov.uk' }
    password { 'change_me' }
    admin { false }
    confirmed_at { Time.now }

    factory :admin do
      email { 'admin@justice.gov.uk' }
      admin { true }
    end
  end
end
