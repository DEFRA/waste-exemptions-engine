# frozen_string_literal: true

require "rspec/expectations"

RSpec::Matchers.define :have_html_escaped_string do |expected|
  match do |actual|
    actual.include?(CGI.escape_html(expected))
  end
end
