# frozen_string_literal: true

require 'faker'

puts 'Creating admin user admin@justice.gov.uk/change_me'
User.create!(
  email: 'admin@justice.gov.uk',
  password: 'change_me',
  admin: true,
  confirmed_at: Time.now
)

puts 'Creating normal user user@justice.gov.uk/change_me'
User.create!(
  email: 'user@justice.gov.uk',
  password: 'change_me',
  admin: false,
  confirmed_at: Time.now
)

puts 'Creating 10 normal users'
10.times do
  User.create!(
    email: "#{Faker::Name.first_name}@justice.gov.uk",
    password: 'change_me',
    admin: false,
    confirmed_at: Time.now
  )
end

puts 'Creating 10 admin users'
10.times do
  User.create!(
    email: "#{Faker::Name.first_name}@justice.gov.uk",
    password: 'change_me',
    admin: true,
    confirmed_at: Time.now
  )
end

puts 'Creating 20 submitted ideas'
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

puts 'Creating 10 unsubmitted ideas'
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

puts 'Creating comment for each approved idea'
Idea.find_each do |idea|
  if idea.approved?
    user = User.offset(rand(User.count)).first
    idea.comments.create!(
      body: Faker::ChuckNorris.fact,
      user: user
    )
  end
end
