# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe IncorrectCompaniesHouseDetailsForm, type: :model do
    describe "#submit" do
      let(:incorrect_companies_house_details_form) { build(:incorrect_companies_house_details_form) }

      context "when the form is valid" do
        let(:valid_params) { { token: incorrect_companies_house_details_form.token } }

        it "should submit" do
          expect(incorrect_companies_house_details_form.submit(valid_params)).to be_truthy
        end
      end

      context "when the form is not valid" do
        before do
          expect(incorrect_companies_house_details_form).to receive(:valid?).and_return(false)
        end

        it "should not submit" do
          expect(incorrect_companies_house_details_form.submit({})).to be_falsey
        end
      end
    end
  end
end
