# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Errors", type: :request do
    describe "GET /last-email" do
      context "when `WasteExemptionsEngine.configuration.use_last_email_cache` is \"true\"" do
        before(:context) do
          WasteExemptionsEngine.configuration.use_last_email_cache = "true"
        end

        it "returns the JSON value of the LastEmailCacheService" do
          ConfirmationMailer.send_confirmation_email(create(:registration), "test@example.com").deliver_now
          get last_email_path
          expect(response.body).to eq(WasteExemptionsEngine::LastEmailCacheService.instance.last_email_json)
        end
      end

      context "when `WasteExemptionsEngine.configuration.use_last_email_cache` is anything other than \"true\"" do
        before(:context) { WasteExemptionsEngine.configuration.use_last_email_cache = "false" }

        before(:each) do
          skip "There is a bug in the engine routing which means all requests that should 404 " \
            "get swallowed up by the errors route and result in a 500."
        end

        it "renders the error_404 template" do
          get last_email_path
          expect(response.location).to include("errors/404")
        end

        it "responds with a status of 404" do
          get last_email_path
          expect(response.code).to eq("404")
        end
      end

      context "when `WasteExemptionsEngine.configuration.use_last_email_cache` is missing" do
        before(:context) { WasteExemptionsEngine.configuration.use_last_email_cache = nil }

        before(:each) do
          skip "There is a bug in the engine routing which means all requests that should 404 " \
            "get swallowed up by the errors route and result in a 500."
        end

        it "renders the error_404 template" do
          get last_email_path
          expect(response.location).to include("errors/404")
        end

        it "responds with a status of 302" do
          get last_email_path
          expect(response.code).to eq("404")
        end
      end
    end
  end
end
