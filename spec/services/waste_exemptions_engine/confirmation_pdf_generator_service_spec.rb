# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationPdfGeneratorService do
    describe ".run" do
      it "generates and return a string containing PDF content with the confirmation information" do
        registration = create(:registration, :complete)

        result = described_class.run(registration: registration)

        expect(result).to include_pdf_content(registration.reference)
        expect(result).to include_pdf_content(registration.submitted_at.to_formatted_s(:day_month_year))
        expect(result).to include_pdf_content("Limited company")
        expect(result).to include_pdf_content(registration.applicant_phone)
        expect(result).to include_pdf_content(registration.applicant_email)
        expect(result).to include_pdf_content(registration.applicant_first_name)
        expect(result).to include_pdf_content(registration.applicant_last_name)
        expect(result).to include_pdf_content(registration.operator_name)
        expect(result).to include_pdf_content(registration.contact_phone)
        expect(result).to include_pdf_content(registration.contact_email)
        expect(result).to include_pdf_content(registration.contact_first_name)
        expect(result).to include_pdf_content(registration.contact_last_name)
        expect(result).to include_pdf_content(registration.contact_position)

        registration.addresses.each do |address|
          if address.located_by_grid_reference?
            expect(result).to include_pdf_content(address.description)
            expect(result).to include_pdf_content(address.grid_reference)
          else
            expect(result).to include_pdf_content(address.premises)
            expect(result).to include_pdf_content(address.street_address)
            expect(result).to include_pdf_content(address.locality)
            expect(result).to include_pdf_content(address.city)
            expect(result).to include_pdf_content(address.postcode)
          end
        end

        registration.exemptions.each do |exemption|
          expect(result).to include_pdf_content(exemption.code)
        end
      end

      context "when the business is a partnership" do
        it "generates a PDF containing all partners names" do
          registration = create(:registration, :complete, :partnership)

          result = described_class.run(registration: registration)

          registration.people.each do |partner|
            expect(result).to include_pdf_content(partner.first_name)
            expect(result).to include_pdf_content(partner.last_name)
          end
        end
      end

      context "when the site address is lookup" do
        it "generates a PDF containing a normal address for the site" do
          registration = create(:registration, :complete, :with_lookup_site_address)

          result = described_class.run(registration: registration)

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
