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

        it "cannot load the page" do
          expect { get last_email_path }.to raise_error(ActionController::RoutingError)
        end
      end

      context "when `WasteExemptionsEngine.configuration.use_last_email_cache` is missing" do
        before(:context) { WasteExemptionsEngine.configuration.use_last_email_cache = nil }

        it "cannot load the page" do
          expect { get last_email_path }.to raise_error(ActionController::RoutingError)
        end
      end
    end
  end
end
