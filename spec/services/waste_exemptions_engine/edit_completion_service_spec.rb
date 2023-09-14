# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditCompletionService do
    describe "run" do
      let(:edit_registration) { create(:back_office_edit_registration, :modified) }
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

      it "removes no-longer-used attribute from the registration" do
        edit_registration.contact_position = nil
        old_value = registration.contact_position

        expect { run_service }.to change {
          registration.reload.contact_position
        }.from(old_value).to(nil)
      end

      it "deletes the edit_registration" do
        expect(BackOfficeEditRegistration.where(reference: edit_registration.reference).count).to eq(1)
        expect { run_service }.to change(BackOfficeEditRegistration, :count).by(-1)
        expect(BackOfficeEditRegistration.where(reference: edit_registration.reference).count).to eq(0)
      end

      it "deletes the edit_registration addresses" do
        edit_registration_id = BackOfficeEditRegistration.find_by(reference: edit_registration.reference).id
        expect(TransientAddress.where(transient_registration_id: edit_registration_id).count).to eq(3)

        run_service

        expect(TransientAddress.where(transient_registration_id: edit_registration_id).count).to eq(0)
      end

      it "deletes the edit_registration people" do
        edit_registration_id = BackOfficeEditRegistration.find_by(reference: edit_registration.reference).id
        expect(TransientPerson.where(transient_registration_id: edit_registration_id).count).to eq(3)

        run_service

        expect(TransientPerson.where(transient_registration_id: edit_registration_id).count).to eq(0)
      end

      describe "PaperTrail", :versioning do
        it "creates a new version" do
          expect { run_service }.to change { registration.versions.count }.by(1)
        end

        it "includes the new data in the version JSON" do
          new_data = edit_registration.operator_name

          run_service

          expect(registration.reload.versions.last.json.to_s).to include(new_data)
        end

        context "when no data has changed" do
          let(:edit_registration) { create(:back_office_edit_registration) }

          it "does not create a new version" do
            expect { run_service }.not_to change { registration.versions.count }
          end
        end

        context "when only a related address's data has changed" do
          let(:edit_registration) { create(:back_office_edit_registration, :modified_addresses) }

          it "creates a new version" do
            expect { run_service }.to change { registration.versions.count }.by(1)
          end

          it "includes the new data in the version JSON" do
            new_data = edit_registration.contact_address.postcode

            run_service

            expect(registration.reload.versions.last.json.to_s).to include(new_data)
          end
        end

        context "when only a related person's data has changed" do
          let(:edit_registration) { create(:back_office_edit_registration, :modified_people) }

          it "creates a new version" do
            expect { run_service }.to change { registration.versions.count }.by(1)
          end

          it "includes the new data in the version JSON" do
            new_data = edit_registration.people.first.first_name

            run_service

            expect(registration.reload.versions.last.json.to_s).to include(new_data)
          end
        end
      end

      def run_service
        described_class.run(edit_registration: edit_registration)
      end
    end
  end
end
