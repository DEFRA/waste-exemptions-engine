# frozen_string_literal: true

source "https://rubygems.org"

# Declare your gem's dependencies in waste_exemptions_engine.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.

# Temporary workaround until we implement webpack assets
# See: https://github.com/sass/sassc-rails/issues/114
gem "sassc-rails"

gem "govuk_design_system_formbuilder"

group :development do
    # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
    gem "spring"
    gem "spring-commands-rspec"
end

gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.
