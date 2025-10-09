# frozen_string_literal: true

source "https://rubygems.org"

# Declare your gem's dependencies in waste_exemptions_engine.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.

# Temporary workaround until we implement webpack assets
# See: https://github.com/sass/sassc-rails/issues/114
gem "sassc-rails"

gem "govuk_design_system_formbuilder"

gem "matrix"

gem "net-smtp"

# Used for handling background processes
gem "sucker_punch", "~> 3.1"

gem "activerecord-postgis-adapter", require: false
gem "rgeo-geojson"

group :development do
  gem "github_changelog_generator"
  gem "rubocop-factory_bot"
  gem "rubocop-rake"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "bullet"
  gem "defra_ruby_style"
  gem "dotenv-rails"
  gem "faraday-retry"
  gem "pdf-reader"
  gem "pry-byebug"
  gem "rails-controller-testing"
  gem "rspec-html-matchers"
  gem "simplecov", "~> 0.22.0", require: false
  gem "w3c_validators"
end

group :test do
  gem "database_cleaner"
  gem "factory_bot_rails"
  gem "faker"
  gem "parallel_tests"
  gem "rspec-rails"
  gem "timecop"
  gem "vcr"
  gem "webmock"
end

gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
