# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationNumberForm, type: :model do
    before do
      allow_any_instance_of(DefraRubyValidators::CompaniesHouseService).to receive(:status).and_return(:active)
    end

    describe "#submit" do
      context "when the form is valid" do
        let(:registration_number_form) { build(:registration_number_form) }
        let(:valid_params) { { token: registration_number_form.token, company_no: "09360070" } }

        it "should submit" do
          expect(registration_number_form.submit(valid_params)).to eq(true)
        end

        context "when the company_no is less than 8 characters" do
          before(:each) { valid_params[:company_no] = "946107" }

          it "should increase the length" do
            registration_number_form.submit(valid_params)
            expect(registration_number_form.company_no).to eq("00946107")
          end

          it "should submit" do
            expect(registration_number_form.submit(valid_params)).to eq(true)
          end
        end

        context "when the company_no is lowercase" do
          before(:each) { valid_params[:company_no] = "sc534714" }

          it "should convert company_no to uppercase" do
            registration_number_form.submit(valid_params)
            expect(registration_number_form.company_no).to eq("SC534714")
          end

          it "should submit" do
            expect(registration_number_form.submit(valid_params)).to eq(true)
          end
        end

        context "when the company_no starts or ends with whitespace" do
          before(:each) { valid_params[:company_no] = "  SC534714  " }

          it "should remove the whitespace" do
            registration_number_form.submit(valid_params)
            expect(registration_number_form.company_no).to eq("SC534714")
          end

          it "should submit" do
            expect(registration_number_form.submit(valid_params)).to eq(true)
          end
        end
      end

      context "when the form is invalid" do
        let(:registration_number_form) { build(:registration_number_form) }
        let(:invalid_params) { { token: registration_number_form.token, company_no: "foo" } }

        it "should not submit" do
          expect(registration_number_form.submit(invalid_params)).to eq(false)
        end
      end
    end
  end
end
