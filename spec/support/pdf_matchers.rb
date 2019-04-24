# frozen_string_literal: true

require "rspec/expectations"
require "pdf-reader"

module Helpers
  module PdfMatchersHelper
    def self.extract_pdf_content(pdf_stream)
      temp_pdf = Tempfile.new("pdf")

      ## Most linux systems distinguish between binary and text content files.
      ## The PDF content is not compatible with file managed in text mode.
      ## Tempfile#binmode will tell the system to manage the file in binmode rather
      ## than text mode. This issue does not occur on OSX but it does in most
      ## production servers.
      temp_pdf.binmode

      temp_pdf << pdf_stream
      pdf_text = PDF::Reader.new(temp_pdf).pages.map(&:text).join
      pdf_text = clean_pdf_text(pdf_text)
      temp_pdf.close

      pdf_text
    end

    def self.clean_pdf_text(text)
      text.delete("\n").delete(" ").delete("\t")
    end
  end
end

RSpec::Matchers.define :include_pdf_content do |expected|
  match do |actual|
    @expected = Helpers::PdfMatchersHelper.clean_pdf_text(expected)

    @actual = Helpers::PdfMatchersHelper.extract_pdf_content(actual)
    @actual.include?(@expected)
  end

  failure_message do |_actual|
    "expected that \n#{@actual} \n would include \n#{@expected}"
  end
end
