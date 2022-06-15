# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe "Check Registered Name And Address Forms", type: :request do

    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }

    before do
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company).and_return(true)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:company_name).and_return(company_name)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:registered_office_address_lines).and_return(company_address)
    end

    include_examples "GET form", :check_registered_name_and_address_form, "/check-registered-name-and-address"
    include_examples "go back", :check_registered_name_and_address_form, "/check-registered-name-and-address/back"
    include_examples "POST form", :check_registered_name_and_address_form, "/check-registered-name-and-address" do
      let(:form_data) { { temp_use_registered_company_details: "true" } }
      let(:invalid_form_data) { [{ temp_use_registered_company_details: "" }] }
    end

    context "when check_registered_name_and_address_form is given a valid companies house number" do
      let(:check_registered_name_and_address_form) { build(:check_registered_name_and_address_form) }

      it "displays the registered company name" do
        get "/waste_exemptions_engine/#{check_registered_name_and_address_form.token}/check-registered-name-and-address"

        expect(response.body).to have_html_escaped_string(company_name)
      end

      it "displays the regsitered company address" do
        get "/waste_exemptions_engine/#{check_registered_name_and_address_form.token}/check-registered-name-and-address"

        company_address.each do |line|
          expect(response.body).to include(line)
        end
      end
    end
  end
end
