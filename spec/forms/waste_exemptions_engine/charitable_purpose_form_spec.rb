# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe CharitablePurposeForm, type: :model do
    subject(:form) { build(:charitable_purpose_form) }

    it "validates the charitable purpose question using the TrueFalseValidator class" do
      validators = form._validators
      aggregate_failures do
        expect(validators[:charitable_purpose].first.class)
          .to eq(DefraRuby::Validators::TrueFalseValidator)
      end
    end

    it_behaves_like "a validated form", :charitable_purpose_form do
      let(:valid_params) do
        [
          { charitable_purpose: "true" },
          { charitable_purpose: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { charitable_purpose: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the charitable purpose answer" do
          charitable_purpose = true
          valid_params = { charitable_purpose: charitable_purpose }
          transient_registration = form.transient_registration

          aggregate_failures do
            expect(transient_registration.charitable_purpose).to be_blank
            form.submit(valid_params)
            expect(transient_registration.reload.charitable_purpose).to be_truthy
          end
        end
      end
    end
  end
end
