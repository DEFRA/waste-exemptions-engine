# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe Payment do
    describe "scopes" do
      let(:account) { create(:account) }

      let(:govpay_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_GOVPAY, payment_status: Payment::PAYMENT_STATUS_SUCCESS, account:) }
      let(:bank_transfer_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER, payment_status: Payment::PAYMENT_STATUS_SUCCESS, account:) }
      let(:missing_card_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_MISSING_CARD_PAYMENT, payment_status: Payment::PAYMENT_STATUS_SUCCESS, account:) }
      let(:other_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_OTHER, payment_status: Payment::PAYMENT_STATUS_SUCCESS, account:) }
      let(:already_reversed_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER, payment_status: Payment::PAYMENT_STATUS_SUCCESS) }
      let(:already_refunded_payment) { create(:payment, payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER, payment_status: Payment::PAYMENT_STATUS_SUCCESS) }
      let(:refund) do
        create(:payment, payment_type: Payment::PAYMENT_TYPE_REFUND, account:, associated_payment: already_refunded_payment, payment_amount: already_refunded_payment.payment_amount / 2)
      end
      let(:reversal) { create(:payment, payment_type: Payment::PAYMENT_TYPE_REVERSAL, account:, associated_payment: already_reversed_payment, payment_amount: already_reversed_payment.payment_amount) }

      before do
        govpay_payment
        bank_transfer_payment
        missing_card_payment
        other_payment
        already_reversed_payment
        already_refunded_payment
        refund
        reversal
      end

      describe ".refunds_and_reversals" do
        it "returns only payments of type refund or reversal" do
          expect(described_class.refunds_and_reversals).to contain_exactly(refund, reversal)
        end
      end

      describe ".excluding_refunds_and_reversals" do
        it "returns all payments except refunds and reversals" do
          expect(described_class.excluding_refunds_and_reversals).to contain_exactly(govpay_payment, bank_transfer_payment, missing_card_payment, other_payment, already_reversed_payment, already_refunded_payment)
        end
      end

      describe ".refundable" do
        it "returns payments that are refundable" do
          expect(described_class.refundable).to contain_exactly(govpay_payment, bank_transfer_payment, missing_card_payment, already_reversed_payment, already_refunded_payment)
        end
      end

      describe ".reverseable" do
        it "returns payments that are reverseable" do
          expect(described_class.reverseable).to contain_exactly(bank_transfer_payment, missing_card_payment, other_payment)
        end
      end
    end
  end
end
