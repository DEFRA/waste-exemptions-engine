# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditCompletionService, :versioning do

    editable_attributes =
      %w[
        contact_first_name
        contact_last_name
        contact_phone
        contact_email
      ].freeze

    describe "run" do

      subject(:run_service) { described_class.run(edit_registration: edit_registration) }

      let(:edit_registration) { create(:front_office_edit_registration) }
      let(:registration) { edit_registration.registration }
      let(:contact_changes?) { false }
      let(:exemption_changes?) { false }

      before do
        allow(ExemptionDeregistrationService).to receive(:run).and_call_original
        allow(RegistrationEditConfirmationEmailService).to receive(:run)

        contact_changes? && edit_registration.update(
          contact_first_name: "#{edit_registration.contact_first_name}_x",
          contact_last_name: "#{edit_registration.contact_last_name}_x",
          contact_phone: "0987654321",
          contact_email: "bar@foo.nonsense"
        )
        exemption_changes? && edit_registration.exemption_ids = edit_registration.exemptions[0..-2].pluck(:id)

        edit_registration.save!
      end

      RSpec.shared_examples "does not send a confirmation email" do
        it "does not send the email" do
          run_service

          aggregate_failures do
            expect(ExemptionDeregistrationService).not_to have_received(:run)
            expect(RegistrationEditConfirmationEmailService).to have_received(:run).once
          end
        end
      end

      RSpec.shared_examples "sends a confirmation email via the exemption_deregistration_service" do
        it "sends the email to the contact_email of the transient registration" do
          run_service

          aggregate_failures do
            expect(ExemptionDeregistrationService).to have_received(:run)
            expect(RegistrationEditConfirmationEmailService).to have_received(:run)
              .with(registration:, recipient: edit_registration.contact_email)
              .once
          end
        end
      end

      RSpec.shared_examples "sends a confirmation email outside of the exemption_deregistration_service" do
        it "sends the email" do
          run_service

          aggregate_failures do
            expect(ExemptionDeregistrationService).not_to have_received(:run)
            expect(RegistrationEditConfirmationEmailService).to have_received(:run).once
          end
        end
      end

      RSpec.shared_examples "calls the exemption deregistration service" do
        it "and changes the exemption count" do
          original_count = registration.exemptions.length

          run_service

          aggregate_failures do
            expect(ExemptionDeregistrationService).to have_received(:run)
            expect(registration.reload.exemptions.length).to eq(original_count - 1)
          end
        end
      end

      RSpec.shared_examples "does not call the exemption deregistration service" do
        it "and does not change the exemption count" do
          original_count = registration.exemptions.length

          run_service

          aggregate_failures do
            expect(ExemptionDeregistrationService).not_to have_received(:run)
            expect(registration.reload.exemptions.length).to eq(original_count)
          end
        end
      end

      RSpec.shared_examples "updates contact attribute" do
        it { expect { run_service }.to change { registration.reload.send(modified_attribute) } }
      end

      RSpec.shared_examples "does not update contact attribute" do
        it { expect { run_service }.not_to change { registration.reload.send(modified_attribute) } }
      end

      RSpec.shared_examples "updates contact details" do
        editable_attributes.each do |attribute|
          it_behaves_like "updates contact attribute" do
            let(:registration) { edit_registration.registration }
            let(:modified_attribute) { attribute }
          end
        end
      end

      RSpec.shared_examples "does not update contact details" do
        editable_attributes.each do |attribute|
          it_behaves_like "does not update contact attribute" do
            let(:registration) { edit_registration.registration }
            let(:modified_attribute) { attribute }
          end
        end
      end

      RSpec.shared_examples "creates a new paper_trail version" do
        it "creates a new version" do
          expect { run_service }.to change { registration.versions.count }.by(1)
        end
      end

      RSpec.shared_examples "deletes the transient registration" do
        it { expect { run_service }.to change(FrontOfficeEditRegistration, :count).by(-1) }
      end

      context "with no changes" do
        it_behaves_like "does not update contact details"
        it_behaves_like "does not call the exemption deregistration service"

        it "does not create a new version" do
          expect { run_service }.not_to change { registration.versions.count }
        end

        it "does not send a confirmation email" do
          run_service

          expect(RegistrationEditConfirmationEmailService).not_to have_received(:run)
        end

        it_behaves_like "deletes the transient registration"
      end

      context "with deregistrations but no contact details changes" do
        let(:exemption_changes?) { true }

        it_behaves_like "calls the exemption deregistration service"
        it_behaves_like "sends a confirmation email via the exemption_deregistration_service"
        it_behaves_like "does not update contact details"
        it_behaves_like "creates a new paper_trail version"
        it_behaves_like "deletes the transient registration"
      end

      context "with contact detail changes but no deregistrations" do
        let(:contact_changes?) { true }

        it_behaves_like "updates contact details"
        it_behaves_like "does not call the exemption deregistration service"
        it_behaves_like "sends a confirmation email outside of the exemption_deregistration_service"
        it_behaves_like "creates a new paper_trail version"
        it_behaves_like "deletes the transient registration"
      end

      context "with deregistrations and contact detail changes" do
        let(:exemption_changes?) { true }
        let(:contact_changes?) { true }

        it_behaves_like "calls the exemption deregistration service"
        it_behaves_like "sends a confirmation email via the exemption_deregistration_service"
        it_behaves_like "updates contact details"
        it_behaves_like "deletes the transient registration"
        it { expect { run_service }.to change { registration.versions.count }.by(2) }
      end
    end
  end
end
