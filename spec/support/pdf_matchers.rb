# frozen_string_literal: true

require "rspec/expectations"
require "pdf-reader"

RSpec::Matchers.define :match_pdf_content do |fixtures_path_to_expected_pdf|
  match do |actual|
    expected = PDF::Reader.new(fixtures_path_to_expected_pdf)
    @expected = expected.pages.map(&:text).join
    @expected = @expected.delete("\n").delete(" ").delete("\t")

    temp_pdf = Tempfile.new("pdf")
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
