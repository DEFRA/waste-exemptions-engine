# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationCompletionService do
    let(:new_registration) { create(:new_registration, :complete, workflow_state: "registration_complete_form") }
    let(:registration) { Registration.last }

    let(:registration_completion_service) { RegistrationCompletionService.new(new_registration) }

    describe "#complete" do
      it "is idempotent" do
        expect(WasteExemptionsEngine::Registration.count).to eq(0)
        RegistrationCompletionService.new(new_registration).complete

        expect { RegistrationCompletionService.new(new_registration).complete }.to raise_error

        expect(WasteExemptionsEngine::Registration.count).to eq(1)
      end

      context "when a race condition calls the service twice" do
        it "generates only one record and fail to execute subsequent calls" do
          expect(WasteExemptionsEngine::Registration.count).to eq(0)
          expect(ActiveRecord::Base.connection.pool.size).to be > 3

          should_wait = true
          concurrency_level = 4

          begin
            threads = Array.new(concurrency_level) do |i|
              Thread.new do
                while should_wait do
                  # Do nothing, just wait
                end

                begin
                  registration_completion_service.complete
                rescue StandardError
                end
              end
            end
          ensure
            ActiveRecord::Base.connection_pool.disconnect!
          end

          should_wait = false
          threads.each(&:join)

          expect(WasteExemptionsEngine::Registration.count).to eq(1)

          # Clean up after the threads have executed
          WasteExemptionsEngine::Address.delete_all
          WasteExemptionsEngine::Person.delete_all
          WasteExemptionsEngine::RegistrationExemption.delete_all
          WasteExemptionsEngine::Registration.delete_all
        end
      end
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

        it "sends a confirmation email to both the applicant and the contant emails" do
          old_emails_sent_count = ActionMailer::Base.deliveries.count

          registration_completion_service.complete

          expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 2)
        end

        context "when applicant and contact emails coincide" do
          let(:new_registration) { create(:new_registration, :complete, :same_applicant_and_contact_email) }

          it "only sends one confirmation email" do
            old_emails_sent_count = ActionMailer::Base.deliveries.count

            registration_completion_service.complete

            expect(ActionMailer::Base.deliveries.count).to eq(old_emails_sent_count + 1)
          end
        end
      end
    end
  end
end
