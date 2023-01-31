# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmEditExemptionsFormsController, type: :request do
    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      let(:form) { build(:confirm_edit_exemptions_form) }
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/confirm-edit-exemptions" }

      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/confirm_edit_exemptions_forms/new")
        end
      end
    end
  end
end
