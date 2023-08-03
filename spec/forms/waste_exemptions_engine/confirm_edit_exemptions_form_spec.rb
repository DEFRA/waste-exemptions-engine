# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmEditExemptionsForm, type: :model do
    subject(:form) { build(:confirm_edit_exemptions_form) }

    it "validates the edit confirmation question using the YesNoValidator class" do
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
  end
end
