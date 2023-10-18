# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RegistrationCompletionService do
    let(:new_registration) { create(:new_registration, :complete, workflow_state: "registration_complete_form") }
    let(:registration) { Registration.last }

    describe "#complete" do

      subject(:run_service) { described_class.run(transient_registration: new_registration) }

      it "is idempotent" do
        run_service
        run_service

        expect(WasteExemptionsEngine::Registration.count).to eq(1)
      end

      context "when a race condition calls the service twice" do
        it { expect(ActiveRecord::Base.connection.pool.size).to be > 3 }

        it "generates only one record and fails to execute subsequent calls" do
          should_wait = true
          concurrency_level = 4

          begin
            threads = Array.new(concurrency_level) do
              Thread.new do
                while should_wait
                  # Do nothing, just wait
                end

                begin
                  run_service
                rescue StandardError
                  Rails.logger.info "Expected spec exception"
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
        before do
          allow(ConfirmationEmailService).to receive(:run)
          allow(NotifyConfirmationLetterService).to receive(:run)
        end

        it "copies attributes from the new_registration to the registration" do
          new_registration_attribute = new_registration.operator_name
          run_service
          registration_attribute = registration.operator_name
          expect(registration_attribute).to eq(new_registration_attribute)
        end

        it "copies attributes from associated transient objects to non-transient objects" do
          new_registration_attribute = new_registration.site_address.description
          run_service
          registration_attribute = registration.site_address.description
          expect(registration_attribute).to eq(new_registration_attribute)
        end

        it "sets the correct value for submitted_at" do
          run_service
          expect(registration.submitted_at).to eq(Date.current)
        end

        context "when the transient registration's assistance mode is set" do
          before do
            allow(new_registration).to receive(:assistance_mode).and_return("foo")
          end

          it "sets the registration's assistance mode to the same value" do
            run_service
            expect(registration.reload.assistance_mode).to eq("foo")
          end
        end

        context "when the transient registration's assistance mode is not set" do
          before do
            allow(new_registration).to receive(:assistance_mode).and_return(nil)
          end

          it "sets the registration's assistance mode to nil" do
            run_service
            expect(registration.reload.assistance_mode).to be_nil
          end
        end

        it "deletes the new_registration" do
          run_service
          expect(NewRegistration.where(reference: new_registration.reference).count).to eq(0)
        end

        context "when the contact email is not blank (AD)" do
          it "sends a confirmation email to both the applicant and the contact emails" do
            run_service

            aggregate_failures do
              expect(ConfirmationEmailService).to have_received(:run).with(registration: instance_of(Registration),
                                                                           recipient: new_registration.applicant_email)
              expect(ConfirmationEmailService).to have_received(:run).with(registration: instance_of(Registration),
                                                                           recipient: new_registration.contact_email)
            end
          end

          it "does not send a confirmation letter" do
            run_service

            expect(NotifyConfirmationLetterService).not_to have_received(:run)
          end

          context "when applicant and contact emails coincide" do
            let(:new_registration) { create(:new_registration, :complete, :same_applicant_and_contact_email) }

            it "only sends one confirmation email" do
              run_service

              expect(ConfirmationEmailService).to have_received(:run).with(registration: instance_of(Registration),
                                                                           recipient: new_registration.applicant_email).once
            end
          end
        end

        context "when the contact email is blank (AD)" do
          let(:new_registration) { create(:new_registration, :complete, :has_no_email) }

          context "when the applicant email is blank (AD)" do
            before { new_registration.update(applicant_email: new_registration.contact_email) }

            it "sends a confirmation letter" do
              run_service

              expect(NotifyConfirmationLetterService).to have_received(:run).with(registration: instance_of(Registration)).once
            end

            it "does not send any confirmation emails" do
              run_service

              expect(ConfirmationEmailService).not_to have_received(:run)
            end
          end

          context "when the applicant email is not blank" do
            it "sends a confirmation letter" do
              run_service

              expect(NotifyConfirmationLetterService).to have_received(:run).with(registration: instance_of(Registration)).once
            end

            it "only emails the applicant email" do
              run_service

              aggregate_failures do
                expect(ConfirmationEmailService).to have_received(:run).with(registration: instance_of(Registration),
                                                                             recipient: new_registration.applicant_email).once
                expect(ConfirmationEmailService).not_to have_received(:run).with(registration: instance_of(Registration),
                                                                                 recipient: new_registration.contact_email)
              end
            end
          end
        end

        context "when the transient registration is a renewal" do
          let(:renewing_registration) { create(:renewing_registration) }

          it "copies over data about the referring registration" do
            referring_registration = renewing_registration.referring_registration

            new_registration = described_class.run(transient_registration: renewing_registration)

            aggregate_failures do
              expect(new_registration.referring_registration).to eq(referring_registration)
              expect(referring_registration.referred_registration).to eq(new_registration)
            end
          end
        end

        context "when the transient_registration has people" do
          context "when the organisation is a partnership" do
            let(:new_registration) { create(:new_registration, :complete, :has_people, :partnership) }

            it "copies the people" do
              people_count = new_registration.people.count

              registration = described_class.run(transient_registration: new_registration)

              expect(registration.people.count).to eq(people_count)
            end
          end

          context "when the organisation is not a partnership" do
            let(:new_registration) { create(:new_registration, :complete, :has_people, :sole_trader) }

            it "does not copy the people" do
              registration = described_class.run(transient_registration: new_registration)

              expect(registration.people.count).to eq(0)
            end
          end
        end

        context "when the transient_registration has a company_no" do
          context "when the organisation type uses a company_no" do
            let(:new_registration) { create(:new_registration, :complete, :has_company_no, :limited_company) }

            it "copies the company_no" do
              company_no = new_registration.company_no

              registration = described_class.run(transient_registration: new_registration)

              expect(registration.company_no).to eq(company_no)
            end
          end

          context "when the organisation type does not use a company_no" do
            let(:new_registration) { create(:new_registration, :complete, :has_company_no, :sole_trader) }

            it "does not copy the company_no" do
              registration = described_class.run(transient_registration: new_registration)

              expect(registration.company_no).to be_nil
            end
          end
        end
      end
    end
  end
end
