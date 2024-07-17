# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Exemptions Summary Forms" do
    let(:form) { build(:exemptions_summary_form) }

    describe "GET exemptions_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/exemptions-summary" }

      it "renders the appropriate template", :vcr do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/exemptions_summary_forms/new")
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

    describe "POST exemptions_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/exemptions-summary" }
      let(:request_body) { { exemptions_summary_form: { token: form.token } } }
      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
