# frozen_string_literal: true

require "rails_helper"
require "./spec/models/waste_exemptions_engine/concerns/can_sort_exemption_codes"

module WasteExemptionsEngine
  RSpec.describe DataOverviewPresenter, type: :presenter do
    let(:new_registration) do
      create(:new_registration,
             :complete)
    end

    subject(:presenter) { described_class.new(new_registration) }

    describe "#company_rows" do
      let(:expected_business_address_link_suffix) do
        formatted_business_type = WasteExemptionsEngine::TransientRegistration::BUSINESS_TYPES.key(new_registration.business_type)
        I18n.t("#{presenter.send(:company_i18n_scope)}.operator_address.change_link_suffix.#{formatted_business_type}")
      end
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
            value: new_registration.company_no,
            change_link_suffix: "Business name",
            change_url: "check-your-answers/registration-number"
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
            ].join("<br>").html_safe,
            change_url: "check-your-answers/operator-address",
            change_link_suffix: expected_business_address_link_suffix
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
            title: "Contact telephone number",
            value: new_registration.contact_phone,
            change_link_suffix: "contact telephone number",
            change_url: "check-your-answers/contact-phone"
          },
          {
            title: "Contact email address",
            value: new_registration.contact_email,
            change_link_suffix: "contact email address",
            change_url: "check-your-answers/contact-email"
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
          expected_data[2] = {
            title: "Partners",
            value: partner_text,
            change_url: "check-your-answers/main-people",
            change_link_suffix: I18n.t("#{presenter.send(:company_i18n_scope)}.partners.change_link_suffix")
          }
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
            value: new_registration.exemptions.map(&:code).join(", "),
            change_link_suffix: "Exemptions selected",
            change_url: "check-your-answers/exemptions",
            renewal_change_url: "renewal-start/exemptions"
          },
          {
            title: "Will this waste operation take place on a farm?",
            value: "Yes",
            change_link_suffix: "Will this operation be carried out on a farm?",
            change_url: "check-your-answers/on-a-farm"
          },
          {
            title: "Are the waste exemptions used by a farmer or farming business?",
            value: "Yes",
            change_link_suffix: "Are these exemptions used by a farmer or farming business?",
            change_url: "check-your-answers/is-a-farmer"
          },
          {
            title: "Form completed by",
            value: "#{new_registration.applicant_first_name} #{new_registration.applicant_last_name}",
            change_link_suffix: "Form completed by",
            change_url: "check-your-answers/applicant-name",
            renewal_change_url: "renewal-start/applicant-name"
          },
          {
            title: "Telephone number",
            value: new_registration.applicant_phone,
            change_link_suffix: "Telephone number of the person filling in this form",
            change_url: "check-your-answers/applicant-phone",
            renewal_change_url: "renewal-start/applicant-phone"
          },
          {
            title: "Email address",
            value: new_registration.applicant_email,
            change_link_suffix: "Email address of the person filling in this form",
            change_url: "check-your-answers/applicant-email",
            renewal_change_url: "renewal-start/applicant-email"
          },
          {
            title: "Grid reference",
            value: new_registration.site_address.grid_reference,
            change_url: "check-your-answers/site-grid-reference",
            change_link_suffix: "Grid reference",
            merged_with: :site_description
          },
          {
            title: "Site description",
            value: new_registration.site_address.description,
            change_url: "check-your-answers/site-grid-reference",
            change_link_suffix: "Site description"
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
            ].join("<br>").html_safe,
            change_link_suffix: "Site address",
            change_url: "check-your-answers/check-site-address"
          }
          expected_data.delete_at(7)
        end

        it "returns the properly-formatted data" do
          expect(presenter.registration_rows).to eq(expected_data)
        end
      end
    end

    context "when presenter has CanSortExemptionCodes concern included" do
      it_behaves_like "can_sort_exemption_codes", described_class
    end
  end
end
