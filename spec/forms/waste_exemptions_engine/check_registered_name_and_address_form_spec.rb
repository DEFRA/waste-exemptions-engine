# frozen_string_literal: true

require "rails_helper"
require "defra_ruby_companies_house"

module WasteExemptionsEngine
  RSpec.describe CheckRegisteredNameAndAddressForm, type: :model do
    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }

    before do
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:load_company)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:company_name).and_return(company_name)
      allow_any_instance_of(DefraRubyCompaniesHouse).to receive(:registered_office_address_lines).and_return(company_address)
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
      let(:form) { build(:check_registered_name_and_address_form) }

      subject do
        form.submit(temp_use_registered_company_details: temp_use_registered_company_details)
      end

      context "when temp_use_registered_company_details is true" do
        let(:temp_use_registered_company_details) { "yes" }

        it "assigns the registered company name as the operator name" do
          subject

          expect(form.registered_company_name).to eq(form.operator_name)
        end
      end

      context "when temp_use_registered_company_details is false" do
        let(:temp_use_registered_company_details) { "no" }

        it "does not assign the operator name" do
          subject

          expect(form.transient_registration.operator_name).to be_blank
        end
      end
    end
  end
end
