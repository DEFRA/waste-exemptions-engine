# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe BetaParticipantsController, type: :request do
    let(:beta_participant) { create(:beta_participant) }
    let(:participant_token) { beta_participant.token }

    shared_examples "redirect to private beta unavailable" do
      it "redirects to private beta unavailable page" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(private_beta_unavailable_path(participant_token: participant_token))
        end
      end
    end

    shared_examples "redirect to private beta invalid token" do
      it "redirects to invalid_token page" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:found)
          expect(response).to redirect_to(private_beta_invalid_token_path(participant_token: participant_token))
        end
      end
    end

    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(true)
    end

    describe "#opt-in" do
      let(:request_path) { "/waste_exemptions_engine/beta/#{participant_token}/opt-in" }

      context "when the feature toggle is not set or inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(false)
        end

        it_behaves_like "redirect to private beta unavailable"
      end

      context "when participant token is invalid" do
        let(:participant_token) { "INVALID_TOKEN" }

        it_behaves_like "redirect to private beta invalid token"
      end

      context "when participant token is valid" do
        it "redirects to opt-in confirmation page" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(opt_in_confirmation_beta_participants_path(participant_token: participant_token))
          end
        end
      end
    end

    describe "#opt-out" do
      let(:request_path) { "/waste_exemptions_engine/beta/#{participant_token}/opt-out" }

      context "when the feature toggle is not set or inactive" do
        before do
          allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:private_beta).and_return(false)
        end

        it_behaves_like "redirect to private beta unavailable"
      end

      context "when participant token is invalid" do
        let(:participant_token) { "INVALID_TOKEN" }

        it_behaves_like "redirect to private beta invalid token"
      end

      context "when participant token is valid" do
        it "redirects to opt-out confirmation page" do
          get request_path

          aggregate_failures do
            expect(response).to have_http_status(:found)
            expect(response).to redirect_to(opt_out_confirmation_beta_participants_path(participant_token: participant_token))
          end
        end
      end
    end

    describe "#opt-out-confirmation" do
      let(:request_path) { "/waste_exemptions_engine/beta/#{participant_token}/opt-out-confirmation" }

      it "renders private beta opt-out-confirmation template" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/beta_participants/opt_out_confirmation")
        end
      end
    end

    describe "#opt-in-confirmation" do
      let(:request_path) { "/waste_exemptions_engine/beta/#{participant_token}/opt-in-confirmation" }

      it "renders private beta opt-in-confirmation template" do
        get request_path

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response).to render_template("waste_exemptions_engine/beta_participants/opt_in_confirmation")
        end
      end
    end
  end
end
