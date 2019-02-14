# frozen_string_literal: true

require 'faker'

puts 'Creating production seed data...'

puts 'Creating admin user'
User.find_or_create_by!(email: 'laa-great-ideas@digital.justice.gov.uk') do |user|
  user.password = SecureRandom.hex(10)
  user.admin = true
  user.confirmed_at = Time.now
end
