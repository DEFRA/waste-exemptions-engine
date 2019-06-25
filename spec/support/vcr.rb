# frozen_string_literal: true

# Stubbing HTTP requests
require "webmock/rspec"
# Auto generate fake responses for web-requests
require "vcr"

require_relative "helpers/html_body_content_matcher"

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock

  c.ignore_hosts "127.0.0.1", "codeclimate.com"

  c.default_cassette_options = { re_record_interval: 14.days }

  # Strip out authorization info
  c.filter_sensitive_data("Basic <API_KEY>") do |interaction|
    auth = interaction.request.headers["Authorization"]
    auth.first unless auth.nil? || auth.empty?
  end

  c.register_request_matcher :html_body_content do |request_one, request_two|
    HtmlBodyContentMatcher.new(request_one, request_two).match?
  end
end
