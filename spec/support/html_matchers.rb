# frozen_string_literal: true

require "rspec/expectations"
require "w3c_validators"

RSpec::Matchers.define :have_valid_html do
  match do |actual|
    validator = W3CValidators::NuValidator.new
    vcr_options = { match_requests_on: %i[html_body_content] }

    # In order to avoid slowing down the test suite matching Body content of the
    # W3C tests, we want to have one cassette per request test.
    # To achieve this, the following method access the running scenarios metadata and
    # uses the `rerun_file_path` to get the running test path and uses it to create
    # a folder in which to put cassettes.
    # It then uses the `description` to build a file name for the cassette and support different
    # page renders in the same test file.
    # We used `rerun_file_path` instead of `file_path` as `file_path` will return
    # the path of shared example rather than running scenario.
    example_metadata = method_missing(:class).metadata
    example_path = example_metadata[:rerun_file_path].split("/").last.gsub(".rb", "")
    example_file_name = example_metadata[:description].gsub(/\W/, " ").gsub(/\s+/, "-")

    @results = VCR.use_cassette("w3c_valid_content/#{example_path}/#{example_file_name}", vcr_options) do
      validator.validate_text(actual)
    end

    return false if @results.errors.any?

    true
  end

  failure_message do |_actual|
    "Invalid HTML: \n#{@results.errors.map(&:to_s).join("\n")}"
  end
end

RSpec::Matchers.define :have_html_escaped_string do |expected|
  match do |actual|
    actual.include?(CGI.escape_html(expected))
  end
end
