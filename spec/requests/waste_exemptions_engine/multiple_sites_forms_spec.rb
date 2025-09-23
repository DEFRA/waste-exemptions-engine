# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Multiple Sites Forms" do
    before do
      allow(WasteExemptionsEngine::FeatureToggle).to receive(:active?).with(:enable_multisite).and_return(true)
    end

    let(:form) { build(:multiple_sites_form) }

    describe "GET multiple_sites_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/multiple-sites" }

      it "renders the appropriate template", :vcr do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/multiple_sites_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path
        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path
        expect(response.body).to have_valid_html
      end

      context "with page parameter" do
        it "returns a success response" do
          get request_path, params: { page: 2 }
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "POST multiple_sites_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/multiple-sites" }
      let(:request_body) { { multiple_sites_form: { token: form.token } } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end

      it "redirects to the multisite exemptions summary form" do
        post request_path, params: request_body
        expect(response).to redirect_to(multisite_exemptions_summary_forms_path(form.token))
      end

      context "with page parameter" do
        it "redirects to the next step" do
          post request_path, params: request_body.merge(page: 2)
          expect(response).to have_http_status(:see_other)
        end
      end
    end

    context "when on Multiple Sites page during Check Your Answers flow - new registration" do
      let(:multiple_sites_form) { build(:check_your_answers_multiple_sites_form) }

      it "continues through multisite workflow when submitted" do
        post "/waste_exemptions_engine/#{multiple_sites_form.token}/multiple-sites",
             params: { multiple_sites_form: { token: multiple_sites_form.token } }

        expect(response).to redirect_to(multisite_exemptions_summary_forms_path(multiple_sites_form.token))
      end
    end
  end
end
