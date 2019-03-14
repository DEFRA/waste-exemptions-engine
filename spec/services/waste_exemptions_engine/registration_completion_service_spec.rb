# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationCompletionService do
    let(:transient_registration) { create(:transient_registration, :complete, workflow_state: "registration_complete_form") }
    let(:registration) { Registration.where(reference: transient_registration.reference).first }

    let(:registration_completion_service) { RegistrationCompletionService.new(transient_registration) }

    describe "#complete" do
      context "when the registration can be completed" do
        it "copies attributes from the transient_registration to the registration" do
          transient_registration_attribute = transient_registration.operator_name
          registration_completion_service.complete
          registration_attribute = registration.operator_name
          expect(registration_attribute).to eq(transient_registration_attribute)
        end

        it "copies attributes from associated transient objects to non-transient objects" do
          transient_registration_attribute = transient_registration.site_address.description
          registration_completion_service.complete
          registration_attribute = registration.site_address.description
          expect(registration_attribute).to eq(transient_registration_attribute)
        end

        it "sets the correct value for submitted_at" do
          registration_completion_service.complete
          expect(registration.submitted_at).to eq(Date.current)
        end

        it "deletes the transient registration" do
          registration_completion_service.complete
          expect(TransientRegistration.where(reference: transient_registration.reference).count).to eq(0)
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
