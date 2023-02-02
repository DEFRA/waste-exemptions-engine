# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditExemptionsDeclarationFormsController, type: :request do
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit-exemptions-declaration" }
    let(:form) { build(:edit_exemptions_declaration_form) }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/edit_exemptions_declaration_forms/new")
        end
      end
    end
  end
end
