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
      benefits { 0 }
      impact { 'Impact' }
      involvement { 0 }

      factory :submitted_idea do
        submission_date { Time.now }

        factory :approved_idea do
          status { Idea.statuses[:approved] }
        end
      end
    end
  end
end
