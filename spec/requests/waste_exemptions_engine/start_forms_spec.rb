# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Start Forms", type: :request do
    let(:form) { build(:start_form) }

    describe "GET start_form" do
      let(:request_path) { "/waste_exemptions_engine/start/#{form.token}" }

      it "renders the appropriate template" do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/start_forms/new")
      end

      it "responds to the GET request with a 200 status code" do
        get request_path
        expect(response.code).to eq("200")
      end

      it "returns W3C valid HTML content", vcr: true do
        get request_path
        expect(response.body).to have_valid_html
      end
    end

    describe "POST start_form" do
      let(:request_path) { "/waste_exemptions_engine/start/" }
      let(:request_body) { { start_form: { token: form.token, start: "new" } } }
      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      # A successful POST request redirects to the next form in the work flow. We have chosen to
      # differentiate 'good' rediection as 303 and 'bad' redirection as 302.
      it "responds to the POST request with a #{status_code} status code" do
        post request_path, request_body
        expect(response.code).to eq(status_code.to_s)
      end
    end
  end
end
