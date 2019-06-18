# frozen_string_literal: true

require "rspec/expectations"
require "w3c_validators"

RSpec::Matchers.define :have_valid_html do
  match do |actual|
    @validator = W3CValidators::NuValidator.new
    vcr_options = { match_requests_on: %i[uri method html_body_content], record: :new_episodes }
    @results = VCR.use_cassette("w3c_valid_content", vcr_options) do
      @validator.validate_text(actual)
    end

    return false if @results.errors.any?

    true
  end

  failure_message do |_actual|
    "Invalid HTML: \n#{@results.errors.map(&:to_s).join("\n")}"
  end
end
