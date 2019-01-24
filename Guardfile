# frozen_string_literal: true

guard :rspec, cmd: 'NO_COVERAGE=true bundle exec rspec' do
  require 'guard/rspec/dsl'
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper)  { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  dsl.watch_spec_files_for(ruby.lib_files)

  # Rails files
  rails = dsl.rails(view_extensions: %w[erb haml slim])
  dsl.watch_spec_files_for(rails.app_files)

  watch(rails.controllers) { |m| rspec.spec.call("requests/#{m[1]}") }

  # Rails config changes
  watch(rails.app_controller) { "#{rspec.spec_dir}/requests" }

  # Capybara features specs
  watch(rails.view_dirs) { "#{rspec.spec_dir}/system" }
  watch(rails.layouts)   { "#{rspec.spec_dir}/system" }
end
