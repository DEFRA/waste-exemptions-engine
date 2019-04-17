# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationPdfGeneratorService do
    describe ".send_confirmation_email" do
      it "generates and return a string containing PDF content with the confirmation information" do
        travel_to Time.local(2018, 1, 1, 1, 5, 0)
        registration = create(:registration, :confirmable)
        fixtures_file_path = Rails.root.join("..", "fixtures/pdfs/confirmation.pdf")

        result = ConfirmationPdfGeneratorService.run(registration: registration)

        ## Generate new fixtures PDF when a change has been made
        # File.open(fixtures_file_path, 'wb') { |file| file << result }

        expect(result).to match_pdf_content(fixtures_file_path)
      end
    end
  end
end
