# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmEditExemptionsForm, type: :model do
    subject(:form) { build(:confirm_edit_exemptions_form) }

    describe "#workflow_state_options_for_select" do
      subject(:options) { form.workflow_state_options_for_select }

      it "returns a struct with Yes/No options" do
        aggregate_failures do
          expect(options.size).to eq(2)

          expect(options.first.id).to eq("edit_exemptions_declaration_form")
          expect(options.first.name).to eq("Yes")

          expect(options.second.id).to eq("edit_exemptions_form")
          expect(options.second.name).to eq("No")
        end
      end
    end
  end
end
