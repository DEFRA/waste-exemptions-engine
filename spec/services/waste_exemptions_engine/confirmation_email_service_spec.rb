# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationEmailService do

    describe "run" do

      let(:registration) { create(:registration, :complete) }
      let(:recipient) { registration.contact_email }
      let(:run_service) do
        described_class.run(registration: registration, recipient: recipient)
      end

      before { allow(registration).to receive(:reference).and_return("TEST") }

      it_behaves_like "CanHaveCommunicationLog" do
        let(:service_class) { described_class }
        let(:a_registration) { create(:registration, :complete) }
        let(:parameters) { { registration: a_registration, recipient: a_registration.contact_email } }
      end

      context "when the PDF is generated" do
        it "sends an email" do
          VCR.use_cassette("confirmation_email") do
            response = run_service

            aggregate_failures do
              expect(response).to be_a(Notifications::Client::ResponseNotification)
              expect(response.template["id"]).to eq("98d5dcee-ea29-415f-952e-b8e287555e10")
              expect(response.content["subject"]).to eq("Waste exemptions registration TEST completed")
            end
          end
        end
      end

      context "when the PDF fails to generate" do
        before { allow(ConfirmationPdfGeneratorService).to receive(:run).and_raise(StandardError) }

        it "sends an email" do
          VCR.use_cassette("confirmation_email_no_certificate") do
            response = run_service

            aggregate_failures do
              expect(response).to be_a(Notifications::Client::ResponseNotification)
              expect(response.template["id"]).to eq("8fcf5d04-944f-4cd1-b261-962fedd3859f")
              expect(response.content["subject"]).to eq("Waste exemptions registration TEST completed")
            end
          end
        end
      end
    end
  end
end
