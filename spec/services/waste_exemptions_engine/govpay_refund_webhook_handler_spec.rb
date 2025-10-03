# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayRefundWebhookHandler do
    describe ".run" do

      subject(:run_service) { described_class.run(webhook_body) }

      let(:webhook_body) { JSON.parse(file_fixture("govpay/webhook_refund_update_body.json").read) }
      let(:govpay_payment_id) { webhook_body["resource_id"] }

      let(:registration) { create(:registration, :complete, account: build(:account)) }
      let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }
      let!(:wex_original_payment) do
        create(:payment,
               :govpay,
               govpay_id: govpay_payment_id,
               order: order,
               account: registration.account,
               payment_status: Payment::PAYMENT_STATUS_SUCCESS)
      end

      before do
        webhook_body["resource_id"] = wex_original_payment.govpay_id
        webhook_body["resource"]["payment_id"] = wex_original_payment.govpay_id
      end

      shared_examples "failed refund update" do
        it { expect { run_service }.to raise_error(ArgumentError) }

        it_behaves_like "logs an error"
      end

      context "when the update is not for a refund" do
        before { webhook_body["event_type"] = "card_payment_succeeded" }

        it_behaves_like "failed refund update"
      end

      context "when the update is for a refund" do
        context "when original payment record does not exist" do
          before { wex_original_payment.destroy! }

          it_behaves_like "failed refund update"
        end

        context "when original payment record exists" do
          let(:refunded_amount) { webhook_body.dig("resource", "refund_summary", "amount_submitted").to_i }

          it "creates a new refund payment" do
            expect { run_service }.to change(Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND), :count).by(1)
          end

          it { expect { run_service }.to change(Payment, :count).by(1) }

          it "creates a refund with correct attributes" do
            run_service
            new_refund = Payment.last

            aggregate_failures do
              expect(new_refund.payment_type).to eq Payment::PAYMENT_TYPE_REFUND
              expect(new_refund.payment_amount).to eq 0 - refunded_amount
              expect(new_refund.payment_status).to eq Payment::PAYMENT_STATUS_SUCCESS
              expect(new_refund.account_id).to eq wex_original_payment.account_id
              expect(new_refund.payment_uuid).to be_present
              expect(new_refund.associated_payment).to eq wex_original_payment
              expect(new_refund.refunded_payment_govpay_id).to eq wex_original_payment.govpay_id
            end
          end

          context "when a full refund already exists" do
            before do
              create(:payment,
                     payment_type: Payment::PAYMENT_TYPE_REFUND,
                     refunded_payment_govpay_id: wex_original_payment.govpay_id,
                     payment_amount: wex_original_payment.payment_amount)
            end

            it "does not create a refund" do
              expect { run_service }.not_to change(Payment, :count)
            end
          end

          context "when a partial refund already exists" do
            before do
              create(:payment,
                     payment_type: Payment::PAYMENT_TYPE_REFUND,
                     refunded_payment_govpay_id: wex_original_payment.govpay_id,
                     payment_amount: wex_original_payment.payment_amount - refunded_amount - 5)
            end

            it { expect { run_service }.to change(Payment, :count).by(1) }

            it "uses the correct refunded amount" do
              run_service

              expect(Payment.last.payment_amount).to eq(0 - refunded_amount)
            end
          end
        end
      end
    end
  end
end
