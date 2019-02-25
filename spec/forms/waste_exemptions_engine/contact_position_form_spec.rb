# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactPositionForm, type: :model do
    subject(:form) { build(:contact_position_form) }

    it "validates the phone number using the ContactPositionForm class" do
      validators = form._validators
      expect(validators.keys).to include(:position)
      expect(validators[:position].first.class)
        .to eq(WasteExemptionsEngine::PositionValidator)
    end

    it_behaves_like "a validated form", :contact_position_form do
      let(:valid_params) do
        [
          { token: form.token, position: "Chief Waste Carrier" },
          { token: form.token, position: "" }
        ]
      end
      let(:invalid_params) do
        [
          { token: form.token, position: Helpers::TextGenerator.random_string(71) },
          { token: form.token, position: "**Invalid_@_Position**" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the contact position" do
          position = "Waste Carrier Manager"
          valid_params = { token: form.token, position: position }
          transient_registration = form.transient_registration

          expect(transient_registration.contact_position).to be_blank
          form.submit(valid_params)
          expect(transient_registration.contact_position).to eq(position)
        end
      end
    end
  end
end
