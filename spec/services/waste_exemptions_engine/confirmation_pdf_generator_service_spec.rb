# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationPdfGeneratorService do
    describe ".run" do
      it "generates and return a string containing PDF content with the confirmation information" do
        Timecop.freeze(Time.local(2018, 1, 1, 1, 5, 0))
        registration = create(:registration, :confirmable)
        fixtures_file_path = Rails.root.join("..", "fixtures/pdfs/confirmation.pdf")

        result = ConfirmationPdfGeneratorService.run(registration: registration)

        ## Generate new fixtures PDF when a change has been made
        # File.open(fixtures_file_path, "wb") { |file| file << result }

        expect(result).to match_pdf_content(fixtures_file_path)
      end

      context "when the business is a partnership" do
        it "generates a PDF containing all partners names" do
          registration = create(:registration, :confirmable, :partnership)

          result = ConfirmationPdfGeneratorService.run(registration: registration)

          partners = registration.people.select(&:partner?)
          partners.each do |partner|
            expect(result).to include_pdf_content(partner.first_name)
            expect(result).to include_pdf_content(partner.last_name)
          end
        end
      end

      context "when the site address is manual" do
        it "generates a PDF containing a normal address for the site" do
          registration = create(:registration, :confirmable, :with_manual_site_address)

          result = ConfirmationPdfGeneratorService.run(registration: registration)

          address = registration.site_address
          expect(result).to include_pdf_content(address.premises)
          expect(result).to include_pdf_content(address.street_address)
          expect(result).to include_pdf_content(address.locality)
          expect(result).to include_pdf_content(address.city)
          expect(result).to include_pdf_content(address.postcode)
        end
      end
    end
  end
end
