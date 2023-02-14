# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ExemptionDeregistrationService do
    describe "run" do
      let(:transient_registration) { create(:renewing_registration) }
      let(:registration) { transient_registration.registration }
      let(:deregistration_confirmation_email_service) { instance_double(DeregistrationConfirmationEmailService) }
      let(:registration_edit_confirmation_email_service) { instance_double(RegistrationEditConfirmationEmailService) }

      subject(:run_service) { described_class.run(transient_registration) }

      before do
        allow(DeregistrationConfirmationEmailService).to receive(:new).and_return(deregistration_confirmation_email_service)
        allow(deregistration_confirmation_email_service).to receive(:run)
        allow(RegistrationEditConfirmationEmailService).to receive(:new).and_return(registration_edit_confirmation_email_service)
        allow(registration_edit_confirmation_email_service).to receive(:run)
      end

      context "with no changes" do
        it "does not modify the registration" do
          expect { run_service }.not_to change(transient_registration, :updated_at)
        end

        it "does not send a deregistration confirmation email" do
          run_service
          expect(deregistration_confirmation_email_service).not_to have_received(:run)
        end

        it "does not send a registration edit confirmation email" do
          run_service
          expect(registration_edit_confirmation_email_service).not_to have_received(:run)
        end

        it "returns false" do
          expect(run_service).to be false
        end
      end

      context "with all exemptions removed" do
        before do
          transient_registration.exemptions = []
          transient_registration.save!
        end

        # the registration does not have a status of its own; status is at the registration_exemption level
        it "deactivates all exemptions for the registration" do
          expect { run_service }.to change { registration.registration_exemptions.pluck(:state).uniq }
            .from(["active"])
            .to(["inactive"])
        end

        it "sets the deregistered_at timestamp for all exemptions" do
          expect { run_service }.to change { registration.registration_exemptions.pluck(:deregistered_at).uniq }
            .from([nil])
            .to([Date.today])
        end

        it "sets the self-serve deregistration message for each registration_exemption" do
          expect { run_service }.to change { registration.registration_exemptions.pluck(:deregistration_message).uniq }
            .from([nil])
            .to([I18n.t("self_serve_deregistration.message")])
        end

        with_versioning do
          it "creates a new registration version" do
            expect { run_service }.to change { registration.versions.count }.by(1)
          end
        end

        it "sends a confirmation email" do
          run_service
          expect(deregistration_confirmation_email_service).to have_received(:run)
        end

        it "returns true" do
          expect(run_service).to be true
        end
      end

      context "with a subset of exemptions removed" do
        let(:removed_exemption_ids) { [registration.registration_exemptions.first.exemption_id, registration.registration_exemptions.last.exemption_id] }

        before do
          transient_registration.exemptions = transient_registration.exemptions.reject do |tre|
            removed_exemption_ids.include?(tre.id)
          end
          transient_registration.save!
        end

        it "removes the exemptions" do
          expect { run_service }.to change { registration.registration_exemptions.where(state: "inactive").count }
            .from(0)
            .to(removed_exemption_ids.length)
        end

        it "deactivates the removed exemptions" do
          expect { run_service }.to change { removed_registration_exemptions.pluck(:state).uniq }
            .to(["inactive"])
        end

        it "sets the deregistered_at timestamp each removed exemption" do
          expect { run_service }.to change { removed_registration_exemptions.pluck(:deregistered_at).uniq }
            .to([Date.today])
        end

        it "sets the self-serve deregistration message for each removed exemption" do
          expect { run_service }.to change { removed_registration_exemptions.pluck(:deregistration_message).uniq }
            .to([I18n.t("self_serve_deregistration.message")])
        end

        it "does not modify the remaining exemptions" do
          expect { run_service }.not_to change { (registration.exemptions - removed_registration_exemptions).pluck(:updated_at) }
        end

        with_versioning do
          it "creates a new registration version" do
            expect { run_service }.to change { registration.versions.count }.by(1)
          end
        end

        it "sends a confirmation email" do
          run_service
          expect(registration_edit_confirmation_email_service).to have_received(:run)
        end

        it "returns true" do
          expect(run_service).to be true
        end
      end

      def removed_registration_exemptions
        registration.reload.registration_exemptions.select { |ex| removed_exemption_ids.include?(ex.exemption_id) }
      end
    end
  end
end
