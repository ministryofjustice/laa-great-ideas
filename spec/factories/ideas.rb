# frozen_string_literal: true

FactoryBot.define do
  factory :idea do
    association :user, factory: :user, strategy: :build
    title { 'New idea1' }

    factory :complete_idea do
      area_of_interest { 0 }
      business_area { 0 }
      it_system { 0 }
      idea { 'Idea' }
      impact { 'Impact' }
      involvement { 0 }
      after(:create) do |idea|
        FactoryBot.create_list(:benefit, 1, idea: idea, benefit: :cost)
      end

      factory :submitted_idea do
        after(:create) do |idea|
          idea.submission_date = Time.now
          idea.status = Idea.statuses[:awaiting_approval]
        end

        factory :approved_idea do
          status { Idea.statuses[:approved] }
        end
      end
    end
  end
end
