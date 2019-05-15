# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditCompletionService do
    describe "run" do
      let(:edit_registration) { create(:edit_registration, :modified) }
      let(:registration) { edit_registration.registration }

      skipped_attributes = %w[registration_id
                              transient_registration_id
                              created_at
                              updated_at
                              id]

      (Helpers::ModelProperties::REGISTRATION - %i[reference submitted_at]).each do |attribute|
        it "updates the registration data for #{attribute}" do
          old_value = registration[attribute]
          new_value = edit_registration[attribute]

          expect { run_service }.to change {
            registration.reload[attribute]
          }.from(old_value).to(new_value)
        end
      end

      %i[operator_address contact_address site_address].each do |address_type|
        it "copies the #{address_type} from the registration" do
          old_attributes = registration.send(address_type).attributes.except(*skipped_attributes)
          new_attributes = edit_registration.send(address_type).attributes.except(*skipped_attributes)

          expect { run_service }.to change {
            registration.reload.send(address_type).attributes.except(*skipped_attributes)
          }.from(old_attributes).to(new_attributes)
        end
      end

      it "copies the people from the registration" do
        old_people_data = registration.people.map do |person|
          person.attributes.except(*skipped_attributes)
        end

        new_people_data = edit_registration.people.map do |person|
          person.attributes.except(*skipped_attributes)
        end

        expect { run_service }.to change {
          # Get all attributes from all the registration's people
          registration.reload.people.map do |person|
            person.attributes.except(*skipped_attributes)
          end
        }.from(old_people_data).to(new_people_data)
      end

      it "does not change the status of unmodified registration_exemptions" do
        registration.registration_exemptions.first.update(state: "foo")
        edit_registration.exemptions << registration.exemptions.first

        expect { run_service }.to_not change { registration.reload.registration_exemptions.first.state }
      end

      it "do not removes inactive registrations" do
        revoked_exemption_registration = registration.registration_exemptions.first
        revoked_exemption_registration.update! state: :revoked

        run_service
        expect(registration.reload.exemptions).to include(revoked_exemption_registration.exemption)
      end

      it "removes no-longer-used attribute from the registration" do
        edit_registration.contact_position = nil
        old_value = registration.contact_position

        expect { run_service }.to change {
          registration.reload.contact_position
        }.from(old_value).to(nil)
      end

      it "deletes the edit_registration" do
        expect(EditRegistration.where(reference: edit_registration.reference).count).to eq(1)
        expect { run_service }.to change {
          EditRegistration.count
        }.by(-1)
        expect(EditRegistration.where(reference: edit_registration.reference).count).to eq(0)
      end

      def run_service
        described_class.run(edit_registration: edit_registration)
      end
    end
  end
end
