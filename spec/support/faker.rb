# frozen_string_literal: true

# We use this to generate fake data. We believe it is more realistic to use
# nondeterministic data in tests as it better represents actual usage and is more
# likely to highlight issues in our app
require "faker"

Faker::Config.locale = "en-GB"
