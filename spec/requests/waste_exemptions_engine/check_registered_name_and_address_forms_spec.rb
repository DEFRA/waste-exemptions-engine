# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe "Check Registered Name And Address Forms", type: :request do

    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
    let(:request_path) { "/waste_exemptions_engine/#{check_registered_name_and_address_form.token}/check-registered-name-and-address" }

    before do
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company).and_return(true)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:company_name).and_return(company_name)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:registered_office_address_lines).and_return(company_address)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:status).and_return(:active)
    end

    include_examples "GET form", :check_registered_name_and_address_form, "/check-registered-name-and-address"
    include_examples "go back", :check_registered_name_and_address_form, "/check-registered-name-and-address/back"
    include_examples "POST form", :check_registered_name_and_address_form, "/check-registered-name-and-address" do
      let(:form_data) { { temp_use_registered_company_details: "true" } }
      let(:invalid_form_data) { [{ temp_use_registered_company_details: "" }] }
    end

    context "during a new registration" do
      context "when check_registered_name_and_address_form is given a valid companies house number" do
        let(:check_registered_name_and_address_form) { build(:check_registered_name_and_address_form) }

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

    context "during a renewal" do
      let(:check_registered_name_and_address_form) { build(:check_registered_name_and_address_form) }

      context "when the company status is no longer active" do

        before do
          allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:status).and_return(:inactive)
        end

        it "displays inactive company error" do
          get request_path

          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/check_registered_name_and_address_forms/inactive_company")
          expect(response.body).to have_valid_html
        end
      end

      context "when the company house is down" do
        before do
          allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company).and_return(nil)
        end

        it "raises an error" do
          expect { get request_path }.to raise_error(StandardError)
        end
      end

      context "when the company status cannot be found" do
        before do
          allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:status).and_return(:not_found)
        end
        it "raises an error" do
          expect { get request_path }.to raise_error(StandardError)
        end
      end

      context "when the company status throws an error" do
        before do
          allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:status).and_return(:StandardError)
        end
        it "raises an error" do
          expect { get request_path }.to raise_error(StandardError)
        end
      end

    end
  end
end
