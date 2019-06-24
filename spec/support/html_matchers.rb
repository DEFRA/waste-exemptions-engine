# frozen_string_literal: true

require "rspec/expectations"
require "w3c_validators"

RSpec::Matchers.define :have_valid_html do
  match do |actual|
    @validator = W3CValidators::NuValidator.new
    vcr_options = { match_requests_on: %i[html_body_content], record: :once }

    cassette_name = method_missing(:class).metadata[:rerun_file_path].split("/").last.gsub(".rb", "")

    @results = VCR.use_cassette("w3c_valid_content/#{cassette_name}", vcr_options) do
      @validator.validate_text(actual)
    end

    return false if @results.errors.any?

    true
  end

  failure_message do |_actual|
    "Invalid HTML: \n#{@results.errors.map(&:to_s).join("\n")}"
  end
end
