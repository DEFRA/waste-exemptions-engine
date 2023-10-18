# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OperatorPostcodeForm, type: :model do
    subject(:form) { build(:operator_postcode_form) }

    it_behaves_like "a validated form", :operator_postcode_form do
      let(:valid_params) { { temp_operator_postcode: "BS1 5AH" } }
      let(:invalid_params) do
        [
          { temp_operator_postcode: Helpers::TextGenerator.random_string(256) },
          { temp_operator_postcode: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the operator postcode" do
          postcode = "BS1 5AH"
          valid_params = { temp_operator_postcode: postcode }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.temp_operator_postcode).to be_blank
            form.submit(valid_params)
            expect(transient_registration.temp_operator_postcode).to eq(postcode)
          end
        end
      end
    end
  end
end
