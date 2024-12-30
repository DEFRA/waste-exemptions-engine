# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationNumberForm, type: :model do
    let(:company_name) { Faker::Company.name }
    let(:company_address) { ["10 Downing St", "Horizon House", "Bristol", "BS1 5AH"] }
    let(:companies_house_api) { instance_double(DefraRuby::CompaniesHouse::API) }
    let(:companies_house_api_reponse) do
      {
        company_name:,
        registered_office_address: company_address,
        company_status: :active
      }
    end

    before do
      allow(DefraRuby::CompaniesHouse::API).to receive(:new).and_return(companies_house_api)
      allow(companies_house_api).to receive(:run).and_return(companies_house_api_reponse)
    end

    subject(:form) { build(:registration_number_form) }

    it "validates the company number using the CompaniesHouseNumberValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:temp_company_no].first.class)
          .to eq(DefraRuby::Validators::CompaniesHouseNumberValidator)
      end
    end

    it_behaves_like "a validated form", :registration_number_form do
      let(:valid_params) { { temp_company_no: "09360070" } }
      let(:invalid_params) { { temp_company_no: "foo" } }
    end

    describe "#submit" do
      context "when the form is valid" do
        let(:valid_params) { { temp_company_no: "09360070" } }

        it "updates the transient registration with the registration number" do
          company_number = valid_params[:temp_company_no]
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.temp_company_no).to be_blank
            form.submit(valid_params)
            expect(transient_registration.temp_company_no).to eq(company_number)
            expect(transient_registration.company_no).to be_nil
          end
        end

        context "when the temp_company_no is less than 8 characters" do
          before { valid_params[:temp_company_no] = "946107" }

          it "pads temp_company_no with 0s" do
            form.submit(valid_params)
            expect(form.temp_company_no).to eq("00946107")
          end

          it "submits" do
            expect(form.submit(valid_params)).to be(true)
          end
        end

        context "when the temp_company_no is lowercase" do
          before { valid_params[:temp_company_no] = "sc534714" }

          it "converts temp_company_no to uppercase" do
            form.submit(valid_params)
            expect(form.temp_company_no).to eq("SC534714")
          end

          it "submits" do
            expect(form.submit(valid_params)).to be(true)
          end
        end

        context "when the temp_company_no starts or ends with whitespace" do
          before { valid_params[:temp_company_no] = "  SC534714  " }

          it "removes the whitespace" do
            form.submit(valid_params)
            expect(form.temp_company_no).to eq("SC534714")
          end

          it "submits" do
            expect(form.submit(valid_params)).to be(true)
          end
        end

        # Tehse specs are specific to back_office_edit_registrations which, unlike front-end
        # transient registrations, do not have a confirmation page.
        context "when the registration number form is submitted in the back office" do
          subject(:form) { build(:back_office_edit_registration_number_form) }

          let(:transient_registration) { form.transient_registration }

          before { valid_params[:temp_company_no] = "12345678" }

          # This spec is to ensure that a company number entered during a back-office edit is stored
          # as a copyable attribute on the transient registration.
          it "updates the company_no attribute on the transient registration" do
            expect { form.submit(valid_params) }.to change { transient_registration.reload.company_no }.to("12345678")
          end

          # This spec is to ensure that the registered company name retrieved during a back-office edit is stored
          # as a copyable attribute on the transient registration.
          it "updates the operator_name attribute on the transient registration" do
            expect { form.submit(valid_params) }.to change { transient_registration.reload.operator_name }.to(company_name)
          end
        end
      end
    end
  end
end
