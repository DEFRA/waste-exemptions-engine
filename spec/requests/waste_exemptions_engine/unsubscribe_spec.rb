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

        it "creates a communication log entry" do
          expect do
            get unsubscribe_registration_path(unsubscribe_token:)
          end.to change { registration.communication_logs.count }.by(1)
        end

        describe "the created communication log entry" do
          before do
            get unsubscribe_registration_path(unsubscribe_token:)
          end

          let(:communication_log) { registration.communication_logs.last }

          it "has the correct message_type" do
            expect(communication_log.message_type).to eq("email")
          end

          it "has a nil template_id" do
            expect(communication_log.template_id).to be_nil
          end

          it "has the correct template_label" do
            expect(communication_log.template_label).to eq("User unsubscribed from renewal reminders")
          end

          it "has the correct sent_to value" do
            expect(communication_log.sent_to).to eq(registration.contact_email)
          end
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
