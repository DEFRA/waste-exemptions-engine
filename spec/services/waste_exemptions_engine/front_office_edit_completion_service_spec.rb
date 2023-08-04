# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FrontOfficeEditCompletionService do
    describe "run" do

      subject(:run_service) { described_class.run(edit_registration: edit_registration) }

      let(:edit_registration) { create(:front_office_edit_registration) }
      let(:registration) { edit_registration.registration }

      # force instantiation
      before { edit_registration }

      editable_attributes = %w[
        contact_first_name
        contact_last_name
        contact_phone
        contact_email
      ]

      context "with no changes" do
        editable_attributes.each do |attribute|
          it "does not modify the registration data for #{attribute}" do
            expect { run_service }.not_to change { registration.reload[attribute] }
          end

          it "deletes the edit_registration" do
            expect { run_service }.to change(FrontOfficeEditRegistration, :count).by(-1)
          end
        end
      end

      context "with changes" do
        before do
          edit_registration.update(
            contact_first_name: "#{edit_registration.contact_first_name}_x",
            contact_last_name: "#{edit_registration.contact_last_name}_x",
            contact_phone: "0987654321",
            contact_email: "bar@foo.nonsense"
          )
          edit_registration.exemption_ids = edit_registration.exemptions[0..-2].pluck(:id)
          edit_registration.save!
        end

        editable_attributes.each do |attribute|
          it "updates the registration data for #{attribute}" do
            old_value = registration[attribute]
            new_value = edit_registration[attribute]

            expect { run_service }.to change {
              registration.reload[attribute]
            }.from(old_value).to(new_value)
          end
        end

        it "updates the registration exemptions" do
          expect { run_service }.to change { registration.reload.exemptions.length }.by(-1)
        end

        it "deletes the edit_registration" do
          expect { run_service }.to change(FrontOfficeEditRegistration, :count).by(-1)
        end
      end
    end
  end
end
