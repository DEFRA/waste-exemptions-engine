# frozen_string_literal: true

module WasteExemptionsEngine
  class GeneratePdfService

    attr_reader :pdf

    def initialize(content)
      @pdf = content ? WickedPdf.new.pdf_from_string(content) : nil
    end

  end
end
