# frozen_string_literal: true

# This file is copied to spec/ when you run 'rails generate rspec:install'
require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require File.expand_path("dummy/config/environment", __dir__)

require "dotenv"
Dotenv.load(File.expand_path("spec/dummy/.env"))

# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
# Add additional requires below this line. Rails is not loaded until this point!

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# We make an exception for simplecov because that will already have been
# required and run at the very top of spec_helper.rb
support_files = Dir["./spec/support/**/*.rb"].reject { |file| file == "./spec/support/simplecov.rb" }
support_files.each { |f| require f }

# Allow an example exception to be cleared. See below regarding W3C / Rails conflict.
module RSpec
  module Core
    class Example
      attr_writer :exception
    end
  end
end

RSpec.configure do |config|
  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.before :each, type: :request do
    config.include WasteExemptionsEngine::Engine.routes.url_helpers
  end

  config.before { Bullet.start_request }
  config.after { Bullet.end_request }
  config.before(:each, bullet: :skip) do
    Bullet.enable = false
  end

  config.after(:each, bullet: :skip) do
    Bullet.enable = true
  end

  # Work around a conflict between Rails 7 button_to HTML and the W3C HTML validator by removing these errors
  # Applies only to specs with tag ":ignore_hidden_autocomplete"
  # https://stackoverflow.com/questions/74256523/rails-button-to-fails-with-w3c-validator
  config.after do |example|
    w3c_error = "An .input. element with a .type. attribute whose value is .hidden. must " \
                "not have an .autocomplete. attribute whose value is .on. or .off."
    if example.exception &&
       example.metadata[:ignore_hidden_autocomplete] &&
       example.exception.message.match(/#{w3c_error}/)
      example.exception = nil
    end
  end
end
