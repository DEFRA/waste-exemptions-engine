# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Multisite Exemptions Summary Forms" do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    let(:form) { build(:multisite_exemptions_summary_form) }

    describe "GET multisite_exemptions_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/multisite-exemptions-summary" }

      it "renders the appropriate template", :vcr do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/multisite_exemptions_summary_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path
        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path
        expect(response.body).to have_valid_html
      end
    end

    describe "POST multisite_exemptions_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/multisite-exemptions-summary" }
      let(:request_body) { { multisite_exemptions_summary_form: { token: form.token } } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end

      it "redirects to the operator postcode form" do
        post request_path, params: request_body
        expect(response).to redirect_to(operator_postcode_forms_path(form.token))
      end
    end

    context "when on Multisite Exemptions Summary page during Check Your Answers flow - new registration" do
      let(:multisite_exemptions_summary_form) { build(:check_your_answers_multisite_exemptions_summary_form) }

      it "directs to check your answers when submitted" do
        post "/waste_exemptions_engine/#{multisite_exemptions_summary_form.token}/multisite-exemptions-summary",
             params: { multisite_exemptions_summary_form: { token: multisite_exemptions_summary_form.token } }

        expect(response).to redirect_to(check_your_answers_forms_path(multisite_exemptions_summary_form.token))
      end
    end
  end
end
