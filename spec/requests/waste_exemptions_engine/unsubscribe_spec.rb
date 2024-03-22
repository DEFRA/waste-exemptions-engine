# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe "UnsubscribeController" do
    describe "GET /registrations/unsubscribe/:unsubscribe_token" do
      let(:registration) { create(:registration) }
      let(:unsubscribe_token) { registration.unsubscribe_token }
      let(:unsubscribe_registration_successful_path) { "/waste_exemptions_engine/registrations/unsubscribe_successful" }
      let(:unsubscribe_registration_failed_path) { "/waste_exemptions_engine/registrations/unsubscribe_failed" }

      context "when the unsubscribe token is valid" do
        it "updates the registration's reminder_opt_in attribute to false" do
          get unsubscribe_registration_path(unsubscribe_token:)
          registration.reload
          expect(registration.reminder_opt_in).to be(false)
        end

        it "redirects to the unsubscribe successful page" do
          get unsubscribe_registration_path(unsubscribe_token:)
          expect(response).to redirect_to(unsubscribe_registration_successful_path)
        end
      end

      context "when the unsubscribe token is invalid" do
        it "redirects to the unsubscribe failed page" do
          get "/waste_exemptions_engine/registrations/unsubscribe/invalid_token"
          get unsubscribe_registration_path(unsubscribe_token: "invalid_token")
          expect(response).to redirect_to(unsubscribe_registration_failed_path)
        end
      end
    end
  end
end
