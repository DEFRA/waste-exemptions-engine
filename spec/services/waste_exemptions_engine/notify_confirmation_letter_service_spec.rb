# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyConfirmationLetterService do
    describe "run" do
      let(:registration) { create(:registration, :complete, :with_active_exemptions) }
      let(:service) do
        NotifyConfirmationLetterService.run(registration: registration)
      end

      it "sends a letter" do
        VCR.use_cassette("notify_confirmation_letter") do
          # Make sure it's a real postcode for Notify validation purposes
          allow_any_instance_of(Address).to receive(:postcode).and_return("BS1 1AA")

          expect_any_instance_of(Notifications::Client).to receive(:send_letter).and_call_original

          response = service

          expect(response).to be_a(Notifications::Client::ResponseNotification)
          expect(response.template["id"]).to eq("81cae4bd-9f4c-4e14-bf3c-44573cee4f5b")
          expect(response.content["subject"]).to include("Confirmation of waste exemption registration")
        end
      end
    end
  end
end
