# # frozen_string_literal: true

# To create profiling reports, uncomment this code.

# require "ruby-prof"

# RSpec.configure do |config|
#   # Clean the database before running tests. Setup as per
#   # https://github.com/DatabaseCleaner/database_cleaner#rspec-example
#   config.before(:suite) do
#     RubyProf.start
#   end

#   config.after(:suite) do |example|
#     result = RubyProf.stop

#     printer = RubyProf::MultiPrinter.new(result)
#     printer.print(:path => ".", :profile => "profile")
#   end
# end
