# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyConfirmationLetterService do

    describe "run" do
      subject(:service) { described_class.run(registration: registration) }

      # Make sure it's a real postcode for Notify validation purposes
      let(:address) { build(:address, postcode: "BS1 1AA") }
      let(:registration) { create(:registration, :complete, :with_active_exemptions) }

      before { allow(Address).to receive(:new).and_return(address) }

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete, :with_active_exemptions) }
        let(:parameters) { { registration: a_registration } }
      end

      it "sends a letter" do
        VCR.use_cassette("notify_confirmation_letter") do
          response = service

          aggregate_failures do
            expect(response).to be_a(Notifications::Client::ResponseNotification)
            expect(response.template["id"]).to eq("81cae4bd-9f4c-4e14-bf3c-44573cee4f5b")
            expect(response.content["subject"]).to include("Confirmation of waste exemption registration")
          end
        end
      end
    end
  end
end
