# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    association :user, factory: :user,  strategy: :build
    association :idea, factory: :idea,  strategy: :build
  end
end
