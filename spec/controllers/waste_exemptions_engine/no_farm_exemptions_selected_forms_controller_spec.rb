# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NoFarmExemptionsSelectedFormsController, type: :request do
    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      let(:form) { build(:no_farm_exemptions_selected_form) }
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/no-farm-exemptions-selected" }

      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/no_farm_exemptions_selected_forms/new")
        end
      end
    end
  end
end
