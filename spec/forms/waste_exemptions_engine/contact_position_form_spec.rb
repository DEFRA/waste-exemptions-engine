# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ContactPositionForm, type: :model do
    subject(:form) { build(:contact_position_form) }

    it "validates the position using the ContactPositionValidator class" do
      validators = form._validators
      expect(validators[:contact_position].first.class)
        .to eq(DefraRuby::Validators::PositionValidator)
    end

    it_behaves_like "a validated form", :contact_position_form do
      let(:valid_params) do
        [
          { contact_position: "Chief Waste Carrier" },
          { contact_position: "" }
        ]
      end
      let(:invalid_params) do
        [
          { contact_position: Helpers::TextGenerator.random_string(71) },
          { contact_position: "**Invalid_@_Position**" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the contact position" do
          contact_position = "Waste Carrier Manager"
          valid_params = { contact_position: contact_position }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.contact_position).to be_blank
            form.submit(valid_params)
            expect(transient_registration.reload.contact_position).to eq(contact_position)
          end
        end
      end
    end
  end
end
