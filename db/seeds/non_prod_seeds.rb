# frozen_string_literal: true

require 'faker'

puts 'Creating non production seed data...'

puts 'Create admin user admin@justice.gov.uk/change_me'
User.create!(
  email: 'admin@justice.gov.uk',
  password: 'change_me',
  admin: true,
  confirmed_at: Time.now
)

puts 'Create normal user user@justice.gov.uk/change_me'
User.create!(
  email: 'user@justice.gov.uk',
  password: 'change_me',
  admin: false,
  confirmed_at: Time.now
)

puts 'Create random users'
10.times do
  User.create!(
    email: "#{Faker::Name.first_name}.#{Faker::Name.unique.last_name}@justice.gov.uk",
    password: 'change_me',
    admin: false,
    confirmed_at: Time.now
  )
end

puts 'Create random admin users'
10.times do
  User.create!(
    email: "#{Faker::Name.first_name}@justice.gov.uk",
    password: 'change_me',
    admin: true,
    confirmed_at: Time.now
  )
end

puts 'Create random ideas'
20.times do
  user = User.offset(rand(User.count)).first
  idea = user.ideas.create!(
    title: Faker::Book.title,
    area_of_interest: Idea.area_of_interests.key(rand(Idea.area_of_interests.count)),
    idea: Faker::TvShows::Simpsons.quote,
    impact: 'Impact',
    involvement: Idea.involvements.key(rand(Idea.involvements.count)),
    status: Idea.statuses.key(rand(Idea.statuses.count))
  )
  idea.it_system = Idea.it_systems.key(rand(Idea.it_systems.count)) if idea.area_of_interest == 'it_development'
  idea.business_area = Idea.business_areas.key(rand(Idea.business_areas.count)) if idea.area_of_interest == 'my_business_area'
  Benefit.create!(idea_id: idea.id, benefit: Benefit.benefits.key(rand(Benefit.benefits.count)))
  unless idea.status == 'draft'
    idea.submission_date = Faker::Time.between(Time.now - 30, Time.now)
    idea.save!
  end
end

puts 'Create random ideas'
10.times do
  user = User.offset(rand(User.count)).first
  idea = user.ideas.create!(
    title: Faker::Book.title,
    area_of_interest: Idea.area_of_interests.key(rand(Idea.area_of_interests.count)),
    business_area: Idea.business_areas.key(rand(Idea.business_areas.count)),
    it_system: Idea.it_systems.key(rand(Idea.it_systems.count)),
    idea: Faker::TvShows::Simpsons.quote,
    impact: 'Impact',
    involvement: Idea.involvements.key(rand(Idea.involvements.count))
  )
  Benefit.create!(idea_id: idea.id, benefit: Benefit.benefits.key(rand(Benefit.benefits.count)))
end

puts 'Create comments'
Idea.find_each do |idea|
  if idea.approved_by_admin?
    user = User.offset(rand(User.count)).first
    idea.comments.create!(
      body: Faker::ChuckNorris.fact,
      user: user,
      redacted: false
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
