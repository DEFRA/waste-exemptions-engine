# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe DataOverviewPresenter, type: :presenter do
    let(:new_registration) do
      create(:new_registration,
             :complete)
    end

    subject(:presenter) { described_class.new(new_registration) }

    describe "#company_rows" do
      let(:expected_data) do
        [
          {
            title: "Business type",
            value: "Limited company"
          },
          {
            title: "Registered name",
            value: new_registration.operator_name
          },
          {
            title: "Companies House number",
            value: new_registration.company_no
          },
          {
            title: "Place of business",
            value: "England"
          },
          {
            title: "Address",
            value: [
              new_registration.operator_address.organisation,
              new_registration.operator_address.premises,
              new_registration.operator_address.street_address,
              new_registration.operator_address.locality,
              new_registration.operator_address.city,
              new_registration.operator_address.postcode
            ].join("<br>").html_safe
          },
          {
            title: "Contact name",
            value: "#{new_registration.contact_first_name} #{new_registration.contact_last_name}",
            change_link_suffix: "contact name",
            change_url: "check-your-answers/contact-name"
          },
          {
            title: "Contact position",
            value: new_registration.contact_position,
            change_link_suffix: "contact position",
            change_url: "check-your-answers/contact-position"
          },
          {
            title: "Contact address",
            value: [
              new_registration.contact_address.organisation,
              new_registration.contact_address.premises,
              new_registration.contact_address.street_address,
              new_registration.contact_address.locality,
              new_registration.contact_address.city,
              new_registration.contact_address.postcode
            ].join("<br>").html_safe,
            change_link_suffix: "contact address",
            change_url: "check-your-answers/contact-address"
          },
          {
            title: "Contact details",
            value: "#{new_registration.contact_phone}<br>#{new_registration.contact_email}".html_safe
          }
        ]
      end

      it "returns the properly-formatted data for a company" do
        expect(presenter.company_rows).to eq(expected_data)
      end

      context "when the company is a charity" do
        before do
          new_registration.business_type = "charity"
          expected_data[0][:value] = "Charity or trust"
          expected_data[1][:title] = "Operator name"
          expected_data.slice!(2)
          expected_data[1][:change_url] = "check-your-answers/operator-name"
          expected_data[1][:change_link_suffix] = I18n.t("#{presenter.send(:company_i18n_scope)}.business_name.operator_name.change_link_suffix")
        end

        it "returns the properly-formatted data" do
          expect(presenter.company_rows).to eq(expected_data)
        end
      end

      context "when the registration is a partnership" do
        let(:new_registration) do
          create(:new_registration,
                 :complete,
                 :partnership,
                 :has_people)
        end

        before do
          first_partner = new_registration.transient_people.first
          second_partner = new_registration.transient_people.last
          partner_text = "#{first_partner.first_name} #{first_partner.last_name}<br>" \
                         "#{second_partner.first_name} #{second_partner.last_name}".html_safe

          expected_data[0][:value] = "Partnership"
          expected_data[1][:title] = "Operator name"

          expected_data[1][:change_url] = "check-your-answers/operator-name"
          expected_data[1][:change_link_suffix] = I18n.t("#{presenter.send(:company_i18n_scope)}.business_name.operator_name.change_link_suffix")
          # Replace the Companies House info with partners instead
          expected_data[2] = { title: "Partners", value: partner_text }
        end

        it "returns the properly-formatted data" do
          expect(presenter.company_rows).to eq(expected_data)
        end
      end
    end

    describe "#registration_rows" do
      let(:expected_data) do
        [
          {
            title: "Exemptions",
            value: new_registration.exemptions.map(&:code).join(", ")
          },
          {
            title: "Will this waste operation take place on a farm?",
            value: "Yes"
          },
          {
            title: "Are the waste exemptions used by a farmer or farming business?",
            value: "Yes"
          },
          {
            title: "Form completed by",
            value: "#{new_registration.applicant_first_name} #{new_registration.applicant_last_name}"
          },
          {
            title: "Telephone number",
            value: new_registration.applicant_phone
          },
          {
            title: "Email address",
            value: new_registration.applicant_email
          },
          {
            title: "Grid reference",
            value: new_registration.site_address.grid_reference,
            merged_with: :site_description
          },
          {
            title: "Site description",
            value: new_registration.site_address.description
          }
        ]
      end

      it "returns the properly-formatted data" do
        expect(presenter.registration_rows).to eq(expected_data)
      end

      context "when the site address is a postal address" do
        before do
          new_registration.site_address = create(:transient_address, :site_address, :using_postal_address)

          # Replace the grid reference with postal address instead
          expected_data[6] = {
            title: "Site address",
            value: [
              new_registration.site_address.organisation,
              new_registration.site_address.premises,
              new_registration.site_address.street_address,
              new_registration.site_address.locality,
              new_registration.site_address.city,
              new_registration.site_address.postcode
            ].join("<br>").html_safe
          }
          expected_data.delete_at(7)
        end

        it "returns the properly-formatted data" do
          expect(presenter.registration_rows).to eq(expected_data)
        end
      end
    end
  end
end
