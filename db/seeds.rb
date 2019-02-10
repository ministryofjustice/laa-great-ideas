# frozen_string_literal: true

if Rails.env.production?
  load(Rails.root.join('db', 'seeds', 'prod_seeds.rb'))
else
  load(Rails.root.join('db', 'seeds', 'non_prod_seeds.rb'))
end
