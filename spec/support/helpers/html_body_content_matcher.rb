# frozen_string_literal: true

class HtmlBodyContentMatcher
  def initialize(request_one, request_two)
    @request_one = request_one
    @request_two = request_two
  end

  def match?
    request_one_body == request_two_body
  end

  private

  attr_reader :request_one, :request_two

  def request_one_body
    @_request_one_body ||= normalize(request_one.body)
  end

  def request_two_body
    @_request_two_body ||= normalize(request_two.body)
  end

  # Given that we are only interested in the HTML structure of the body request,
  # in order to keep our ability to crerate fake data for our test scenarios,
  # this method removes all information in and between tags and leave a plain HTML
  # structrue to match rerquests on.
  # This will also make sure the test will fail whenever the HTML structure of a page changes.

  # INPUT:
  # <!DOCTYPE html>
  # <html>
  # <body>
  #   <h1 class="some-class">Some text</h1>
  #   <p>Some more text</p>
  # </body>
  # </html>

  # OUTPUT:
  # <!DOCTYPE html><html><body><h1 class="Classes">Info</h1><p>Info</p></body></html>
  def normalize(string)
    string
      .gsub(/""/, "\"FOO\"")
      .gsub(/"[^"]*"/, "\"Classes\"")
      .gsub(/></, ">BAR<")
      .gsub(/>[^<>]*</, ">Info<")
  end
end
