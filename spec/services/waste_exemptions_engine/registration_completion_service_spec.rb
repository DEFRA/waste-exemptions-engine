# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationCompletionService do
    let(:new_registration) { create(:new_registration, :complete, workflow_state: "registration_complete_form") }
    let(:registration) { Registration.where(reference: new_registration.reference).first }

    let(:registration_completion_service) { RegistrationCompletionService.new(new_registration) }

    describe "#complete" do
      context "when the registration can be completed" do
        it "copies attributes from the new_registration to the registration" do
          new_registration_attribute = new_registration.operator_name
          registration_completion_service.complete
          registration_attribute = registration.operator_name
          expect(registration_attribute).to eq(new_registration_attribute)
        end

        it "copies attributes from associated transient objects to non-transient objects" do
          new_registration_attribute = new_registration.site_address.description
          registration_completion_service.complete
          registration_attribute = registration.site_address.description
          expect(registration_attribute).to eq(new_registration_attribute)
        end

        it "sets the correct value for submitted_at" do
          registration_completion_service.complete
          expect(registration.submitted_at).to eq(Date.current)
        end

        context "when the default_assistance_mode is set" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:default_assistance_mode).and_return("foo")
          end

          it "updates the registration's route to the correct value" do
            registration_completion_service.complete
            expect(registration.reload.assistance_mode).to eq("foo")
          end
        end

        context "when the default_assistance_mode is not set" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:default_assistance_mode).and_return(nil)
          end

          it "updates the registration's route to the correct value" do
            registration_completion_service.complete
            expect(registration.reload.assistance_mode).to eq(nil)
          end
        end

        it "deletes the new_registration" do
          registration_completion_service.complete
          expect(NewRegistration.where(reference: new_registration.reference).count).to eq(0)
        end

        it "sends a confirmation email" do
          old_emails_sent_count = ActionMailer::Base.deliveries.count
          registration_completion_service.complete
          expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 1)
        end
      end
    end
  end
end
