# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationPdfGeneratorService do
    describe ".run" do
      it "generates and return a string containing PDF content with the confirmation information" do
        registration = build(:registration, :confirmable)

        result = described_class.run(registration: registration)

        expect(result).to include_pdf_content(registration.reference)
        expect(result).to include_pdf_content(registration.submitted_at.to_formatted_s(:day_month_year))
      end
    end
  end
end
