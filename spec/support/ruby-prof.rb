# frozen_string_literal: true

require "ruby-prof"

RSpec.configure do |config|
  # Clean the database before running tests. Setup as per
  # https://github.com/DatabaseCleaner/database_cleaner#rspec-example
  config.before(:suite) do
    RubyProf.start
  end

  config.after(:suite) do |example|
    result = RubyProf.stop

    printer = RubyProf::MultiPrinter.new(result)
    printer.print(:path => ".", :profile => "profile")
    # printer.print(File.open)
    # printer.print(STDOUT)
  end
end
