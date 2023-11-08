# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationDetailsPresenter do
    let(:registration) { create(:registration, :complete, :with_active_exemptions) }

    subject(:presenter) { described_class.new(registration) }

    describe "#date_registered" do
      it "returns the correct value" do
        allow(registration.registration_exemptions.first).to receive(:registered_on).and_return(Date.new(2020, 1, 1))
        expect(presenter.date_registered).to eq("1 January 2020")
      end
    end

    describe "#applicant_name" do
      it "returns the correct value" do
        expect(presenter.applicant_name).to eq("#{registration.applicant_first_name} #{registration.applicant_last_name}")
      end
    end

    describe "#applicant_email" do
      context "when an email is present" do
        it "returns the correcrt value" do
          expect(presenter.applicant_email_section).to eq(registration.applicant_email.to_s)
        end
      end

      context "when an email isn't present" do
        let(:registration) { create(:registration, :complete, :with_active_exemptions, applicant_email: email) }
        let(:email) { nil }

        it "returns the correct value" do
          expect(presenter.applicant_email_section).to eq("Email: Not present")
        end
      end
    end

    describe "#contact_name" do
      it "returns the correct value" do
        expect(presenter.contact_name).to eq("#{registration.contact_first_name} #{registration.contact_last_name}")
      end
    end

    describe "#business_details_section" do
      context "when the registration is a sole trader" do
        let(:registration) { create(:registration, :complete, :sole_trader, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          address = registration.operator_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Business or organisation type: Individual or sole trader",
            "Business or organisation name: #{registration.operator_name}",
            "Business or organisation address: #{address_text}"
          ]

          expect(presenter.business_details_section).to eq(expected_array)
        end
      end

      context "when the registration is a partnership" do
        let(:registration) { create(:registration, :complete, :partnership, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          first_partner = "#{registration.people.first.first_name} #{registration.people.first.last_name}"
          second_partner = "#{registration.people.last.first_name} #{registration.people.last.last_name}"
          address = registration.operator_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Business or organisation type: Partnership",
            "Accountable partner 1: #{first_partner}",
            "Accountable partner 2: #{second_partner}",
            "Partnership address: #{address_text}"
          ]

          expect(presenter.business_details_section).to eq(expected_array)
        end
      end

      context "when the registration is a limited company" do
        let(:registration) { create(:registration, :complete, :limited_company, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          address = registration.operator_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Business or organisation type: Limited company",
            "Registered name of the company: #{registration.operator_name}",
            "Registration number of the company: #{registration.company_no}",
            "Registered address of the company: #{address_text}"
          ]

          expect(presenter.business_details_section).to eq(expected_array)
        end
      end
    end

    describe "#contact_details_section" do
      let(:registration) { create(:registration, :complete, :with_active_exemptions, contact_position: position) }

      context "when a contact position is not specified" do
        let(:position) { nil }

        it "returns an array with the correct data and labels" do
          expected_array = [
            "Name: #{registration.contact_first_name} #{registration.contact_last_name}",
            "Telephone: #{registration.contact_phone}",
            "Email: #{registration.contact_email}"
          ]

          expect(presenter.contact_details_section).to eq(expected_array)
        end

        context "when a contact email is not specified" do
          let(:registration) { create(:registration, :complete, :with_active_exemptions, contact_email: email, contact_position: position) }
          let(:email) { nil }
          let(:position) { "Head of Waste" }

          it "returns an array with the correct data and labels" do
            expected_array = [
              "Name: #{registration.contact_first_name} #{registration.contact_last_name}",
              "Position: Head of Waste",
              "Telephone: #{registration.contact_phone}",
              "Email: Not present"
            ]

            expect(presenter.contact_details_section).to eq(expected_array)
          end
        end
      end

      context "when a contact position is specified" do
        let(:position) { "Head of Waste" }

        it "returns an array with the correct data and labels" do
          expected_array = [
            "Name: #{registration.contact_first_name} #{registration.contact_last_name}",
            "Position: Head of Waste",
            "Telephone: #{registration.contact_phone}",
            "Email: #{registration.contact_email}"
          ]

          expect(presenter.contact_details_section).to eq(expected_array)
        end
      end
    end

    describe "#location_section" do
      context "when the site location is an address" do
        let(:registration) { create(:registration, :complete, :with_lookup_site_address, :with_active_exemptions) }

        it "returns an array with the correct data and labels" do
          address = registration.site_address
          address_text = [
            address.organisation,
            address.premises,
            address.street_address,
            address.locality,
            address.city,
            address.postcode
          ].reject(&:blank?).join(", ")

          expected_array = [
            "Waste operation location: #{address_text}"
          ]

          expect(presenter.location_section).to eq(expected_array)
        end
      end

      context "when the site location is a grid reference" do
        let(:registration) { create(:registration, :complete, :with_active_exemptions, :with_short_site_description) }

        it "returns an array with the correct data and labels" do
          expected_array = [
            "Grid reference: #{registration.site_address.grid_reference}",
            "Site details: #{registration.site_address.description}"
          ]

          expect(presenter.location_section).to eq(expected_array)
        end
      end
    end

    describe "#exemptions_section" do
      let(:registration) { create(:registration, :complete, :with_active_exemptions) }
      let(:expected_expiry_date) { 3.years.from_now.strftime("%-d %B %Y") }

      it "returns an array with the correct exemptions" do
        expected_array = []
        registration.registration_exemptions.each do |re|
          expected_array << "#{re.exemption.code}: #{re.exemption.summary} – Expires on #{expected_expiry_date}"
        end

        expect(presenter.exemptions_section).to eq(expected_array)
      end

      context "when some exemptions are not active" do
        before do
          registration.registration_exemptions[1].update(state: "ceased")
          registration.registration_exemptions[2].update(state: "revoked")
        end

        it "only lists active exemptions" do
          active_exemption = registration.registration_exemptions[0].exemption
          expected_array = [
            "#{active_exemption.code}: #{active_exemption.summary} – Expires on #{expected_expiry_date}"
          ]

          expect(presenter.exemptions_section).to eq(expected_array)
        end
      end
    end

    describe "#deregistered_exemptions_section" do
      let(:registration) { create(:registration, :complete, :with_active_exemptions) }

      before do
        registration.registration_exemptions[1].update(deregistered_at: Date.new(2000, 1, 1), state: "ceased")
        registration.registration_exemptions[2].update(deregistered_at: Date.new(2000, 1, 1), state: "revoked")
      end

      it "only lists inactive exemptions" do
        ceased_exemption = registration.registration_exemptions[1].exemption
        revoked_exemption = registration.registration_exemptions[2].exemption
        expected_array = [
          "#{ceased_exemption.code}: #{ceased_exemption.summary} – Ceased on 1 January 2000",
          "#{revoked_exemption.code}: #{revoked_exemption.summary} – Revoked on 1 January 2000"
        ]

        expect(presenter.deregistered_exemptions_section).to eq(expected_array)
      end
    end
  end
end
