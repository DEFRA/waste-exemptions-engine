# frozen_string_literal: true

require "rspec/expectations"
require "pdf-reader"

RSpec::Matchers.define :match_pdf_content do |fixtures_path_to_expected_pdf|
  match do |actual|
    expected = PDF::Reader.new(fixtures_path_to_expected_pdf)
    @expected = expected.pages.map(&:text).join
    @expected = @expected.delete("\n").delete(" ").delete("\t")

    temp_pdf = Tempfile.new("pdf")

    ## Most linux systems distinguish between binary and text content files.
    ## The PDF content is not compatible with file managed in text mode.
    ## Tempfile#binmode will tell the system to manage the file in binmode rather
    ## than text mode. This issue does not occur on OSX but it does in most
    ## production servers.
    temp_pdf.binmode

    temp_pdf << actual
    @actual = PDF::Reader.new(temp_pdf).pages.map(&:text).join
    @actual = @actual.delete("\n").delete(" ").delete("\t")
    temp_pdf.close

    @actual == @expected
  end

  failure_message_for_should do |_actual|
    "expected that \n#{@actual} \n would be equal to \n#{@expected}"
  end
end
