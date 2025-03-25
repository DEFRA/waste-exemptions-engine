# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "ReasonForChange Form" do
    let(:form) { build(:reason_for_change_form) }
    let(:edit_enabled) { "true" }

    before do
      WasteExemptionsEngine.configuration.edit_enabled = edit_enabled
    end

    describe "GET reason_for_change_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/reason-for-change" }

      it "renders the appropriate template, returns a 200 status code and W3C valid HTML content" do
        get request_path

        aggregate_failures do
          expect(response).to render_template("waste_exemptions_engine/reason_for_change_forms/new")
          expect(response).to have_http_status(:ok)
          expect(response.body).to have_valid_html
        end
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is anything other than \"true\"" do
        let(:edit_enabled) { "false" }

        it "raises a page not found error" do
          expect { get request_path }.to raise_error(ActionController::RoutingError)
        end

        it "returns a 404 status page" do
          rails_respond_without_detailed_exceptions do
            get request_path

            expect(response.body).to include(I18n.t("waste_exemptions_engine.errors.error_404.clarification"))
          end
        end
      end
    end

    describe "unable to go submit GET back" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/reason-for-change/back" }

      it "raises an error" do
        expect { get request_path }.to raise_error(ActionController::RoutingError)
      end
    end

    describe "POST reason_for_change_form" do
      let(:request_path) { "/waste_exemptions_engine/#{form.token}/reason-for-change/" }
      let(:request_body) { { reason_for_change_form: { reason_for_change: "a reason" } } }

      it "responds to the POST request with correct status code" do
        post request_path, params: request_body
        expect(response.code).to eq(WasteExemptionsEngine::ApplicationController::SUCCESSFUL_REDIRECTION_CODE.to_s)
      end

      context "when `WasteExemptionsEngine.configuration.edit_enabled` is \"false\"" do
        let(:edit_enabled) { "false" }

        it "raises a page not found error" do
          expect { get request_path, params: request_body }.to raise_error(ActionController::RoutingError)
        end

        it "returns a 404 status page" do
          rails_respond_without_detailed_exceptions do
            get request_path

            expect(response.body).to include(I18n.t("waste_exemptions_engine.errors.error_404.clarification"))
          end
        end
      end
    end

  end
end
