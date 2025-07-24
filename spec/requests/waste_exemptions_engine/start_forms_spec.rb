# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Start Forms" do
    let(:form) { build(:start_form) }

    describe "GET start_form" do
      let(:request_path) { "/waste_exemptions_engine/start" }

      it "renders the appropriate template", :vcr do
        get request_path

        expect(response).to render_template("waste_exemptions_engine/start_forms/new")
      end

      it "returns a 200 status code", :vcr do
        get request_path

        expect(response).to have_http_status(:ok)
      end

      it "returns W3C valid HTML content", :vcr, :ignore_hidden_autocomplete do
        get request_path

        expect(response.body).to have_valid_html
      end

      # This is temporary under https://eaflood.atlassian.net/browse/RUBY-3957
      it "does not present the renew option" do
        get request_path

        expect(response.body).not_to include(I18n.t("waste_exemptions_engine.start_forms.new.options.reregister"))
      end
    end

    describe "POST start_form" do
      let(:request_path) { "/waste_exemptions_engine/start/" }
      let(:request_body) { { start_form: { token: form.token, start_option: "new" } } }

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      # A successful POST request redirects to the next form in the work flow. We have chosen to
      # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
