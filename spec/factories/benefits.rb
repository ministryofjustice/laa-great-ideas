# frozen_string_literal: true

FactoryBot.define do
  factory :benefit do
    association :idea, factory: :idea, strategy: :build
    benefit { :cost }
  end
end
