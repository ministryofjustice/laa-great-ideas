# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    association :user, factory: :user, strategy: :build
    association :idea, factory: :idea, strategy: :build
    body { 'Comment 1' }
    redacted { false }
  end
end
