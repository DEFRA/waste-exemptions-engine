# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewalStartService do
    describe "run" do
      subject(:run_service) { described_class.run(registration:) }

      let(:registration) { create(:registration, :complete) }

      context "when no transient registration already exists for this registration" do
        it "creates a new RenewingRegistration" do
          expect { run_service }.to change(RenewingRegistration, :count).by(1)
        end
      end

      context "when a transient registration already exists for the registration" do
        let!(:existing_transient_registration) { create(:front_office_edit_registration, reference: registration.reference) }
        let(:existing_transient_registration_id) { existing_transient_registration.id }

        it "deletes the preexisting registration" do
          expect { run_service }.to change { TransientRegistration.where(id: existing_transient_registration_id).count }.to(0)
        end

        it "creates a new RenewingRegistration" do
          expect { run_service }.to change(RenewingRegistration, :count).by(1)
        end
      end
    end
  end
end
