# frozen_string_literal: true

require 'faker'

puts 'Creating production seed data...'

puts 'Creating admin user'
User.create!(
  email: 'laa-great-ideas@digital.justice.gov.uk',
  password: 'change_me',
  admin: true,
  confirmed_at: Time.now
)
