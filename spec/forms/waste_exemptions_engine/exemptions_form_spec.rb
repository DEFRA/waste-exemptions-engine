# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionsForm, type: :model do
    before(:all) do
      # Create a selection of exemptions. The ExemptionForm needs this as it
      # will validate the selected exemptions (our params) against the
      # collection of exemptions it pulls from the database.
      create_list(:exemption, 5)
    end

    describe "#submit" do
      context "when the form is valid" do
        let(:form) { build(:exemptions_form) }
        let(:valid_params) { { "token" => form.token, exemptions: %w[1 2 3] } }

        it "should submit" do
          expect(form.submit(valid_params)).to eq(true)
        end
      end

      context "when the form is not valid" do
        let(:form) { build(:exemptions_form) }
        let(:invalid_params) { { token: form.token } }

        it "should not submit" do
          expect(form.submit(invalid_params)).to eq(false)
        end
      end
    end
  end
end
