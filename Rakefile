# frozen_string_literal: true

begin
  require "parallel_tests/tasks"
rescue LoadError
  puts "No parallel_tests available. Perhaps running in production mode?"
end

begin
  require "bundler/setup"
rescue LoadError
  puts "You must `gem install bundler` and `bundle install` to run rake tasks"
end

require "rdoc/task"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title    = "WasteExemptionsEngine"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.md")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

APP_RAKEFILE = File.expand_path("spec/dummy/Rakefile", __dir__)
load "rails/tasks/engine.rake"

load "rails/tasks/statistics.rake"

Dir[File.join(File.dirname(__FILE__), "lib/tasks/**/*.rake")].each { |f| load f }

Bundler::GemHelper.install_tasks

# This is wrapped to prevent an error when rake is called in environments where
# rspec may not be available, e.g. production. As such we don't need to handle
# the error.
# rubocop:disable Lint/HandleExceptions
begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new(:spec)

  task default: :spec
rescue LoadError
  # no rspec available
end
# rubocop:enable Lint/HandleExceptions
