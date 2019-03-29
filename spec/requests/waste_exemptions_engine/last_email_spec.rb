# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "Errors", type: :request do
    describe "GET /last-email" do
      context "when ENV[\"ENABLE_LAST_EMAIL_CACHE\"] is \"true\"" do
        before(:context) do
          ENV["ENABLE_LAST_EMAIL_CACHE"] = "true"
        end

        it "returns the JSON value of the LastEmailCacheService" do
          ConfirmationMailer.send_confirmation_email(create(:registration), "test@example.com").deliver_now
          get last_email_path
          expect(response.body).to eq(WasteExemptionsEngine::LastEmailCacheService.instance.last_email_json)
        end
      end

      context "when ENV[\"ENABLE_LAST_EMAIL_CACHE\"] is anything other than \"true\"" do
        before(:context) { ENV["ENABLE_LAST_EMAIL_CACHE"] = "false" }

        it "renders the error_404 template" do
          get last_email_path
          expect(response.location).to include("errors/404")
        end

        it "responds with a status of 404" do
          get last_email_path
          expect(response.code).to eq("404")
        end
      end

      context "when ENV[\"ENABLE_LAST_EMAIL_CACHE\"] is missing" do
        before(:context) { ENV["ENABLE_LAST_EMAIL_CACHE"] = nil }

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
