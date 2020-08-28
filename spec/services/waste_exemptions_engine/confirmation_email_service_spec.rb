# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationEmailService do
    describe "run" do
      let(:registration) { create(:registration, :complete) }
      let(:recipient) { registration.contact_email }
      let(:service) do
        ConfirmationEmailService.run(registration: registration,
                                     recipient: recipient)
      end

      before { allow(registration).to receive(:reference).and_return("TEST")}

      context "when the PDF is generated" do
        it "sends an email" do
          VCR.use_cassette("confirmation_email") do
            expect_any_instance_of(Notifications::Client).to receive(:send_email).and_call_original

            response = service

            expect(response).to be_a(Notifications::Client::ResponseNotification)
            expect(response.template["id"]).to eq("98d5dcee-ea29-415f-952e-b8e287555e10")
            expect(response.content["subject"]).to eq("Waste exemptions registration TEST completed")
          end
        end
      end

      context "when the PDF fails to generate" do
        before { expect(ConfirmationPdfGeneratorService).to receive(:run).and_raise(StandardError) }

        it "sends an email" do
          VCR.use_cassette("confirmation_email_no_certificate") do
            expect_any_instance_of(Notifications::Client).to receive(:send_email).and_call_original

            response = service

            expect(response).to be_a(Notifications::Client::ResponseNotification)
            expect(response.template["id"]).to eq("8fcf5d04-944f-4cd1-b261-962fedd3859f")
            expect(response.content["subject"]).to eq("Waste exemptions registration TEST completed")
          end
        end
      end
    end
  end
end
