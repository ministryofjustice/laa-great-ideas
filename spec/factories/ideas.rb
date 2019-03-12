# frozen_string_literal: true

FactoryBot.define do
  factory :idea do
    association :user, factory: :user, strategy: :build
    title { 'New idea1' }

    trait :draft do
      status { Idea.statuses[:draft] }
    end
    trait :awaiting_approval do
      status { Idea.statuses[:awaiting_approval] }
    end
    trait :approved do
      status { Idea.statuses[:approved] }
    end
    trait :investigation do
      status { Idea.statuses[:investigation] }
    end
    trait :implementing do
      status { Idea.statuses[:implementing] }
    end
    trait :interim_benefits do
      status { Idea.statuses[:interim_benefits] }
    end
    trait :benefits_realised do
      status { Idea.statuses[:benefits_realised] }
    end
    trait :not_proceeding do
      status { Idea.statuses[:not_proceeding] }
    end

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
          idea.save!
        end

        factory :approved_idea do
          status { Idea.statuses[:approved] }
        end
      end
    end
  end
end
