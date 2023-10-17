# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe "Check Registered Name And Address Forms" do
    let(:check_registered_name_and_address_form) { build(:check_registered_name_and_address_form) }
    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
    let(:request_path) { "/waste_exemptions_engine/#{check_registered_name_and_address_form.token}/check-registered-name-and-address" }
    let(:companies_house_service) { instance_double(DefraRubyCompaniesHouse) }

    before do
      allow(DefraRubyCompaniesHouse).to receive(:new).and_return(companies_house_service)
      allow(companies_house_service).to receive_messages(load_company: true, company_name: company_name, registered_office_address_lines: company_address, status: :active)
    end

    include_examples "GET form", :check_registered_name_and_address_form, "/check-registered-name-and-address"
    include_examples "POST form", :check_registered_name_and_address_form, "/check-registered-name-and-address" do
      let(:form_data) { { temp_use_registered_company_details: "true" } }
      let(:invalid_form_data) { [{ temp_use_registered_company_details: "" }] }
    end

    context "with a new registration" do
      context "when check_registered_name_and_address_form is given a valid companies house number" do
        it "displays the registered company name" do
          get request_path

          expect(response.body).to have_html_escaped_string(company_name)
        end

        it "displays the regsitered company address" do
          get request_path

          company_address.each do |line|
            expect(response.body).to include(line)
          end
        end

        it "displays a link to enter a different number" do
          get request_path

          expect(response.body).to have_html_escaped_string("Enter a different number")
        end
      end
    end

    context "with a renewal" do
      let(:renew_check_registered_name_and_address_form) { build(:renew_check_registered_name_and_address_form) }
      let(:renewing_registration) { renew_check_registered_name_and_address_form.transient_registration }
      let(:request_path) { "/waste_exemptions_engine/#{renewing_registration.token}/check-registered-name-and-address" }

      context "when the company status is no longer active" do
        before { allow(companies_house_service).to receive(:status).and_return(:inactive) }

        it "displays inactive company error" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/check_registered_name_and_address_forms/inactive_company")
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the company number is invalid" do
        before do
          renewing_registration.company_no = "1"
          renewing_registration.save!
        end

        it "displays the inactive company error" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/check_registered_name_and_address_forms/inactive_company")
            expect(response.body).to have_valid_html
          end
        end
      end

      context "when the company house API is down" do
        before { allow(companies_house_service).to receive(:status).and_raise(StandardError) }

        it "raises an error" do
          get request_path
          expect(response).to render_template("waste_exemptions_engine/check_registered_name_and_address_forms/companies_house_down")
        end
      end
    end
  end
end
