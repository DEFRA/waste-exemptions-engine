# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe EditCancellationService do
    describe "run" do
      let(:edit_registration) { create(:back_office_edit_registration, :modified) }
      let(:registration) do
        Registration.where(reference: edit_registration.reference).first
      end
      let(:service) { described_class.run(edit_registration: edit_registration) }

      it "does not modify the registration" do
        expect { service }.not_to change { registration }
      end

      it "deletes the edit_registration" do
        expect { service }.to change { BackOfficeEditRegistration.where(reference: edit_registration.reference).count }.to(0)
      end
    end
  end
end
