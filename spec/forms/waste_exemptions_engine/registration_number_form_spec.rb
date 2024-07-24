# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationNumberForm, type: :model do
    let(:companies_house_validator) { instance_double(DefraRuby::Validators::CompaniesHouseService) }

    before do
      allow(DefraRuby::Validators::CompaniesHouseService).to receive(:new).and_return(companies_house_validator)
      allow(companies_house_validator).to receive(:status).and_return(:active)
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
      end
    end
  end
end
