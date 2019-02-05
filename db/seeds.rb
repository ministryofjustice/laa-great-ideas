# frozen_string_literal: true

require 'faker'

User.create!(
  email: 'admin@justice.gov.uk',
  password: 'change_me',
  admin: true,
  confirmed_at: Time.now
)

User.create!(
  email: 'user@justice.gov.uk',
  password: 'change_me',
  admin: false,
  confirmed_at: Time.now
)

10.times do
  User.create!(
    email: "#{Faker::Name.first_name}.#{Faker::Name.unique.last_name}@justice.gov.uk",
    password: 'change_me',
    admin: false,
    confirmed_at: Time.now
  )
end

10.times do
  User.create!(
    email: "#{Faker::Name.first_name}@justice.gov.uk",
    password: 'change_me',
    admin: true,
    confirmed_at: Time.now
  )
end

20.times do
  user = User.offset(rand(User.count)).first
  user.ideas.create!(
    title: Faker::Book.title,
    submission_date: Faker::Time.between(Time.now - 30, Time.now),
    area_of_interest: Idea.area_of_interests.key(rand(Idea.area_of_interests.count)),
    business_area: Idea.business_areas.key(rand(Idea.business_areas.count)),
    it_system: Idea.it_systems.key(rand(Idea.it_systems.count)),
    idea: Faker::Simpsons.quote,
    benefits: Idea.benefits.key(rand(Idea.benefits.count)),
    impact: 'Impact',
    involvement: Idea.involvements.key(rand(Idea.involvements.count)),
    status: Idea.statuses.key(rand(Idea.statuses.count))
  )
end

10.times do
  user = User.offset(rand(User.count)).first
  user.ideas.create!(
    title: Faker::Book.title,
    area_of_interest: Idea.area_of_interests.key(rand(Idea.area_of_interests.count)),
    business_area: Idea.business_areas.key(rand(Idea.business_areas.count)),
    it_system: Idea.it_systems.key(rand(Idea.it_systems.count)),
    idea: Faker::Simpsons.quote,
    benefits: Idea.benefits.key(rand(Idea.benefits.count)),
    impact: 'Impact',
    involvement: Idea.involvements.key(rand(Idea.involvements.count))
  )
end

Idea.find_each do |idea|
  if idea.approved_by_admin?
    user = User.offset(rand(User.count)).first
    idea.comments.create!(
      body: Faker::ChuckNorris.fact,
      user: user
    )
  end
end

puts 'Adding votes'
3.times do
  Idea.find_each do |idea|
    if idea.approved_by_admin? && [true, false].sample
      user = User.offset(rand(User.count)).first
      unless idea.user_voted?(user)
        idea.votes.create!(
          user: user
        )
      end
    end
  end
end
