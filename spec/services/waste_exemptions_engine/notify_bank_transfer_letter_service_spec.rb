# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe NotifyBankTransferLetterService do
    describe ".run" do
      let(:registration) { create(:registration, :complete, :with_active_exemptions) }
      let(:account) { create(:account, registration: registration) }
      let(:order) { create(:order, account: account) }

      before do
        allow(Rails.configuration).to receive(:use_airbrake).and_return(false)
        allow_any_instance_of(Notifications::Client).to receive(:send_letter).and_return(true)
      end

      it "sends a letter with the correct template ID" do
        expect_any_instance_of(Notifications::Client).to receive(:send_letter)
          .with(hash_including(template_id: "b8b68a4c-adc9-4fe6-86cd-3d5a83822c47"))
          .and_return(true)

        described_class.run(registration: registration)
      end

      it "includes the required personalisation details" do
        payment_details_path = "waste_exemptions_engine.registration_received_pending_payment_forms.new"

        expect_any_instance_of(Notifications::Client).to receive(:send_letter) do |_, params|
          personalisation = params[:personalisation]

          expect(personalisation[:reference]).to eq(registration.reference)
          expect(personalisation[:first_name]).to eq(registration.contact_first_name)
          expect(personalisation[:last_name]).to eq(registration.contact_last_name)
          expect(personalisation[:account_number]).to eq(I18n.t("#{payment_details_path}.account_number_value"))
          expect(personalisation[:sort_code]).to eq(I18n.t("#{payment_details_path}.sort_code_value"))
          expect(personalisation[:iban]).to eq(I18n.t("#{payment_details_path}.iban"))
          expect(personalisation[:swiftbic]).to eq(I18n.t("#{payment_details_path}.swift_bic"))
          expect(personalisation[:currency]).to eq("Sterling")
          expect(personalisation).to include(:address_line_1)
          
          true
        end

        described_class.run(registration: registration)
      end

      it "creates a communication log" do
        expect { described_class.run(registration: registration) }
          .to change(WasteExemptionsEngine::CommunicationLog, :count).by(1)

        log = WasteExemptionsEngine::CommunicationLog.last
        expect(log.message_type).to eq("letter")
        expect(log.template_id).to eq("b8b68a4c-adc9-4fe6-86cd-3d5a83822c47")
        expect(log.template_label).to eq("Registration pending bank transfer payment letter")
      end
    end
  end
end
