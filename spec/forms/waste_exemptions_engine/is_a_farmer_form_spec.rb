# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe IsAFarmerForm, type: :model do
    describe "#submit" do
      context "when the form is valid" do
        let(:form) { build(:is_a_farmer_form) }
        let(:valid_params) { { token: form.token, is_a_farmer: "true" } }

        it "should submit" do
          expect(form.submit(valid_params)).to eq(true)
        end
      end

      context "when the form is invalid" do
        let(:form) { build(:is_a_farmer_form) }
        let(:invalid_params) { { token: form.token, is_a_farmer: "" } }

        it "should not submit" do
          expect(form.submit(invalid_params)).to eq(false)
        end
      end
    end
  end
end
