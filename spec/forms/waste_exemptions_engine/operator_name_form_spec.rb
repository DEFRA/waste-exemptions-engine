# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe OperatorNameForm, type: :model do
    subject(:form) { build(:operator_name_form) }

    it "validates the operator name using the OperatorNameValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:operator_name)
      expect(validators[:operator_name].first.class)
        .to eq(WasteExemptionsEngine::OperatorNameValidator)
    end

    it_behaves_like "a validated form", :operator_name_form do
      let(:valid_params) { { operator_name: "Acme Waste Carriers" } }
      let(:invalid_params) do
        [
          { operator_name: Helpers::TextGenerator.random_string(256) },
          { operator_name: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the operator name" do
          operator_name = "Acme Waste Carriers"
          valid_params = { operator_name: operator_name }
          transient_registration = form.transient_registration

          expect(transient_registration.operator_name).to be_blank
          form.submit(valid_params)
          expect(transient_registration.operator_name).to eq(operator_name)
        end
      end
    end
  end
end
