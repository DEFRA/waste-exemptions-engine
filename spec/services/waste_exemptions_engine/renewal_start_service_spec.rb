# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe RenewalStartService do
    describe "run" do
      let(:service) { RenewalStartService.run(registration: create(:registration, :complete)) }

      it "creates a new RenewingRegistration" do
        expect { service }.to change { RenewingRegistration.count }.by(1)
      end
    end
  end
end
