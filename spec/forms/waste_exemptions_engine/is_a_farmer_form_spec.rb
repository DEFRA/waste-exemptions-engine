# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe IsAFarmerForm, type: :model do
    subject(:form) { build(:is_a_farmer_form) }

    it "validates the is a farmer question using the YesNoValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:is_a_farmer].first.class)
          .to eq(DefraRuby::Validators::TrueFalseValidator)
      end
    end

    it_behaves_like "a validated form", :is_a_farmer_form do
      let(:valid_params) do
        [
          { is_a_farmer: "true" },
          { is_a_farmer: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { is_a_farmer: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the is a farmer answer" do
          is_a_farmer = true
          valid_params = { is_a_farmer: is_a_farmer }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.is_a_farmer).to be_blank
            form.submit(valid_params)
            expect(transient_registration.reload.is_a_farmer).to be_truthy
          end
        end
      end
    end
  end
end
