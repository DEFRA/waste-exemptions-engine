# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationNumberForm, type: :model do
    before do
      allow_any_instance_of(DefraRubyValidators::CompaniesHouseService)
        .to receive(:status)
        .and_return(:active)
    end

    it_behaves_like "a validated form", :registration_number_form do
      let(:valid_params) { { token: form.token, company_no: "09360070" } }
      let(:invalid_params) { { token: form.token, company_no: "foo" } }
    end

    describe "#submit" do
      context "when the form is valid" do
        subject(:form) { build(:registration_number_form) }
        let(:valid_params) { { token: form.token, company_no: "09360070" } }

        context "when the company_no is less than 8 characters" do
          before(:each) { valid_params[:company_no] = "946107" }

          it "should pad company_no with 0s" do
            form.submit(valid_params)
            expect(form.company_no).to eq("00946107")
          end

          it "should submit" do
            expect(form.submit(valid_params)).to eq(true)
          end
        end

        context "when the company_no is lowercase" do
          before(:each) { valid_params[:company_no] = "sc534714" }

          it "should convert company_no to uppercase" do
            form.submit(valid_params)
            expect(form.company_no).to eq("SC534714")
          end

          it "should submit" do
            expect(form.submit(valid_params)).to eq(true)
          end
        end

        context "when the company_no starts or ends with whitespace" do
          before(:each) { valid_params[:company_no] = "  SC534714  " }

          it "should remove the whitespace" do
            form.submit(valid_params)
            expect(form.company_no).to eq("SC534714")
          end

          it "should submit" do
            expect(form.submit(valid_params)).to eq(true)
          end
        end
      end
    end
  end
end
