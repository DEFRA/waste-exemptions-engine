# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmEditExemptionsForm do
    subject(:form) { build(:confirm_edit_exemptions_form) }

    it "validates the form using the YesNoValidator class" do
      validators = form._validators
      expect(validators.keys).to include(:temp_confirm_exemption_edits)
      expect(validators[:temp_confirm_exemption_edits].first.class)
        .to eq(DefraRuby::Validators::TrueFalseValidator)
    end

    it_behaves_like "a validated form", :confirm_edit_exemptions_form do
      let(:valid_params) do
        [
          { temp_confirm_exemption_edits: "true" },
          { temp_confirm_exemption_edits: "false" }
        ]
      end
      let(:invalid_params) do
        [
          { temp_confirm_exemption_edits: "" }
        ]
      end
    end

    describe "#submit" do
      context "when the form is valid" do
        it "updates the transient registration with the answer" do
          valid_params = { temp_confirm_exemption_edits: true }
          transient_registration = form.transient_registration

          expect(transient_registration.temp_confirm_exemption_edits).to be_blank
          form.submit(valid_params)
          expect(transient_registration.reload.temp_confirm_exemption_edits).to be_truthy
        end
      end
    end
  end
end
