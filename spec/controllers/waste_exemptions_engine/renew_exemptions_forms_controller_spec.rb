# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewExemptionsFormsController, type: :request do
    let(:form) { build(:renew_exemptions_form) }
    let(:request_path) { "/waste_exemptions_engine/#{form.token}/renew-exemptions" }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      it "renders the correct template" do
        get request_path

        aggregate_failures do
          expect(response.code).to eq("200")
          expect(response).to render_template("waste_exemptions_engine/renew_exemptions_forms/new")
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
          expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/renew-no-exemptions")
        end
      end
    end
  end
end
