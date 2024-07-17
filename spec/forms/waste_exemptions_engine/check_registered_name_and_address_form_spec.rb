# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe CheckRegisteredNameAndAddressForm, type: :model do
    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
    let(:companies_house_instance) { instance_double(DefraRubyCompaniesHouse) }

    before do
      allow(DefraRubyCompaniesHouse).to receive(:new).and_return(companies_house_instance)
      allow(companies_house_instance).to receive_messages(load_company: true, company_name: company_name, registered_office_address_lines: company_address)
    end

    it_behaves_like "a validated form", :check_registered_name_and_address_form do
      let(:valid_params) do
        [
          { temp_use_registered_company_details: "yes" },
          { temp_use_registered_company_details: "no" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_use_registered_company_details: "" }
        ]
      end
    end

    describe "#submit" do
      let(:form) do
        form = build(:check_registered_name_and_address_form)
        form.transient_registration.temp_company_no = "12345678"
        form
      end

      subject(:submit_form) { form.submit(temp_use_registered_company_details: temp_use_registered_company_details) }

      context "when temp_use_registered_company_details is true" do
        let(:temp_use_registered_company_details) { "true" }

        it "assigns the registered company name as the operator name" do
          submit_form

          expect(form.registered_company_name).to eq(form.operator_name)
        end

        it "assigns the temp_company_no as the company_no" do
          submit_form

          expect(form.temp_company_no).to eq(form.company_no)
        end
      end

      context "when temp_use_registered_company_details is false" do
        let(:temp_use_registered_company_details) { "false" }

        it "does not assign the operator name" do
          submit_form

          expect(form.transient_registration.operator_name).to be_blank
        end

        it "does not assign the temp_company_no as the company_no" do
          submit_form

          expect(form.temp_company_no).not_to eq(form.company_no)
        end
      end
    end
  end
end
