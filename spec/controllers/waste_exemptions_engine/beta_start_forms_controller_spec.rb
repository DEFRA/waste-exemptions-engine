# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BetaStartFormsController, type: :request do
    let(:form) { build(:beta_start_form) }
    let(:request_path) { "/waste_exemptions_engine/beta-start" }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do

      context "when the feature toggle is not set or inactive" do
        it "renders the correct template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:service_unavailable)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/unavailable")
          end
        end
      end

      context "when the feature toggle is active" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(true)
        end

        it "renders the correct template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/new")
          end
        end
      end

    end

    describe "#create" do
      let(:valid_params) { {} }

      it "redirects to the correct workflow step" do
        post request_path, params: valid_params

        form = WasteExemptionsEngine::TransientRegistration.last
        aggregate_failures do
          expect(response).to have_http_status(:see_other)
          expect(response).to redirect_to("/waste_exemptions_engine/#{form.token}/location")
        end
      end
    end
  end
end
