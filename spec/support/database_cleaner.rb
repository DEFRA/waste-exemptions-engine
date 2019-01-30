# frozen_string_literal: true

# Require this to support automatically cleaning the database when testing
require "database_cleaner"

RSpec.configure do |config|
  # Clean the database before running tests
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean
  end
end
