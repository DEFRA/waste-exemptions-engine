# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OnAFarmForm, type: :model do
    describe "#submit" do
      context "when the form is valid" do
        let(:form) { build(:on_a_farm_form) }
        let(:valid_params) { { token: form.token, on_a_farm: "true" } }

        it "should submit" do
          expect(form.submit(valid_params)).to eq(true)
        end
      end

      context "when the form is invalid" do
        let(:form) { build(:on_a_farm_form) }
        let(:invalid_params) { { token: form.token, on_a_farm: "" } }

        it "should not submit" do
          expect(form.submit(invalid_params)).to eq(false)
        end
      end
    end
  end
end
