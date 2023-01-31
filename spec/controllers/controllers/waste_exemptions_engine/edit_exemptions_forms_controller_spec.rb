# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditExemptionsFormsController, type: :request do
    let(:form) { build(:edit_exemptions_form) }
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/edit-exemptions" }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/edit_exemptions_forms/new")
        end
      end
    end

    describe "#create" do
      let(:valid_params) do
        {
          exemption_ids: []
        }
      end

      it "redirects to the correct workflow step" do
        post request_path, params: valid_params

        aggregate_failures do
          expect(response.code).to eq("303")
          expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/confirm-edit-exemptions")
        end
      end
    end
  end
end
