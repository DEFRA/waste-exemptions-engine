# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ConfirmationMailer, type: :mailer do
    before(:all) do
      @service_email = "test@wex.gov.uk"
      WasteExemptionsEngine.configuration.email_service_email = @service_email
    end

    describe "#send_confirmation_email" do
      let(:registration) { create(:registration,) }
      let(:recipient) { "test@example.com" }
      let(:mail) { ConfirmationMailer.send_confirmation_email(registration, recipient) }

      it "uses the correct 'to' address" do
        expect(mail.to).to eq([recipient])
      end

      it "uses the correct 'from' address" do
        expect(mail.from).to eq([@service_email])
      end

      it "uses the correct subject" do
        subject = "Waste exemptions registration #{registration.reference} completed"
        expect(mail.subject).to eq(subject)
      end

      it "includes the correct template in the body" do
        expect(mail.body.encoded).to include("This is not a permit")
      end
    end
  end
end
