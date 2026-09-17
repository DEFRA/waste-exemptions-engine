# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe ProofOfPaymentService do
    subject(:run_service) { described_class.run(registration:) }

    let(:registration) { create(:registration, :complete, account: build(:account), contact_email:) }
    let(:contact_email) { "JO.BLOGGS@example.com" }
    let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }
    let!(:payment) do
      create(:payment,
             account: registration.account,
             payment_status: Payment::PAYMENT_STATUS_SUCCESS,
             payment_amount: order.total_charge_amount)
    end

    before do
      allow(ProofOfPaymentEmailService).to receive(:run)
      allow(ProofOfPaymentLetterService).to receive(:run)
    end

    it "sends an email when the charged balance is fully paid" do
      run_service

      aggregate_failures do
        expect(ProofOfPaymentEmailService).to have_received(:run)
          .with(registration:, recipient: contact_email.downcase)
        expect(ProofOfPaymentLetterService).not_to have_received(:run)
      end
    end

    context "without a contact email" do
      let(:contact_email) { nil }

      it "sends a letter instead" do
        run_service

        aggregate_failures do
          expect(ProofOfPaymentLetterService).to have_received(:run).with(registration:)
          expect(ProofOfPaymentEmailService).not_to have_received(:run)
        end
      end
    end

    context "when the balance is below zero" do
      before { payment.update!(payment_amount: order.total_charge_amount - 1) }

      it "does not send proof of payment" do
        run_service

        expect_no_proof_of_payment
      end
    end

    context "when the balance is above zero" do
      before { payment.update!(payment_amount: order.total_charge_amount + 1) }

      it "does not send proof of payment" do
        run_service

        expect_no_proof_of_payment
      end
    end

    context "when there was no charge" do
      before do
        order.charge_detail.update!(registration_charge_amount: 0,
                                    bucket_charge_amount: 0,
                                    total_charge_amount: 0)
        order.charge_detail.band_charge_details.update_all(initial_compliance_charge_amount: 0,
                                                           additional_compliance_charge_amount: 0)
        payment.update!(payment_amount: 0)
      end

      it "does not send proof of payment" do
        run_service

        expect_no_proof_of_payment
      end
    end

    context "when proof of payment was already emailed" do
      before do
        registration.communication_logs << create(:communication_log,
                                                  template_id: NotificationTemplates::PROOF_OF_PAYMENT_EMAIL)
      end

      it "does not send it again" do
        run_service

        expect_no_proof_of_payment
      end
    end

    context "when proof of payment was already posted" do
      before do
        registration.communication_logs << create(:communication_log,
                                                  template_id: NotificationTemplates::PROOF_OF_PAYMENT_LETTER)
      end

      it "does not send it again" do
        run_service

        expect_no_proof_of_payment
      end
    end

    def expect_no_proof_of_payment
      aggregate_failures do
        expect(ProofOfPaymentEmailService).not_to have_received(:run)
        expect(ProofOfPaymentLetterService).not_to have_received(:run)
      end
    end
  end
end
