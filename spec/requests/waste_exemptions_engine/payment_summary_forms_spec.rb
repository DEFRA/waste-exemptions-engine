# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Payment Summary Forms" do
    let(:form) { build(:payment_summary_form) }

    before do
      form.transient_registration.order = build(:order)
    end

    describe "GET payment_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/payment-summary" }

      it "renders the appropriate template", :vcr do
        get request_path
        expect(response).to render_template("waste_exemptions_engine/payment_summary_forms/new")
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

    describe "POST payment_summary_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/payment-summary" }
      let(:request_body) do
        {
          payment_summary_form: {
            token: form.token,
            temp_payment_method: "card"
          }
        }
      end

      status_code = WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE

      it "responds to the POST request with a #{status_code} status code" do
        post request_path, params: request_body
        expect(response.code).to eq(status_code.to_s)
      end

      context "when submitting invalid data" do
        let(:invalid_request_body) do
          {
            payment_summary_form: {
              token: form.token,
              temp_payment_method: "invalid"
            }
          }
        end

        before do
          post request_path, params: invalid_request_body
        end

        it "renders the form again" do
          expect(response).to render_template("waste_exemptions_engine/payment_summary_forms/new")
        end

        it "displays error messages" do
          expect(response.body).to include("There is a problem")
        end
      end
    end
  end
end
