# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BetaStartFormsController, type: :request do
    let(:form) { build(:beta_start_form) }
    let(:beta_participant) { create(:beta_participant) }
    let(:participant_token) { beta_participant.token }
    let(:request_path) { "/waste_exemptions_engine/beta/#{participant_token}/start" }

    it "is a FormController" do
      expect(described_class.superclass).to eq(WasteExemptionsEngine::FormsController)
    end

    describe "#new" do
      before do
        allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(true)
      end

      context "when the feature toggle is not set or inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(false)
        end

        it "renders the correct template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:service_unavailable)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/unavailable")
          end
        end
      end

      context "when participant token is invalid" do
        let(:participant_token) { "INVALID_TOKEN" }

        it "renders the error template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:unauthorized)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/invalid_token")
          end
        end
      end

      context "when participant token is valid" do
        it "renders the new template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/new")
          end
        end
      end

      context "when participant token is valid but participant already completed a registration" do
        let(:registration) { create(:registration, :complete) }

        it "renders the error template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:unauthorized)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/invalid_token")
          end
        end
      end

      context "when participant token is valid and registration has been partially completed earlier" do
        let(:registration) { create(:new_charged_registration, location: "england") }

        it "renders the new template" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(response).to render_template("waste_exemptions_engine/beta_start_forms/new")
          end
        end

        it "changes button label from 'Start new registration' to 'Continue registration'" do
          get request_path

          expect(response.body).to include I18n.t("waste_exemptions_engine.beta_start_forms.new.continue_registration_button_label")
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
