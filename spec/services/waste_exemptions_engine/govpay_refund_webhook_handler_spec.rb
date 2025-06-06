# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayRefundWebhookHandler do
    describe ".run" do

      subject(:run_service) { described_class.run(webhook_body) }

      let(:webhook_body) { JSON.parse(file_fixture("govpay/webhook_refund_update_body.json").read) }
      let(:govpay_refund_id) { webhook_body["refund_id"] }
      let(:govpay_payment_id) { webhook_body["payment_id"] }

      let(:registration) { create(:registration, :complete, account: build(:account)) }
      let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }
      let!(:wex_original_payment) { create(:payment, order: order, account: registration.account, govpay_id: "789", payment_status: Payment::PAYMENT_STATUS_SUCCESS) }

      let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUBMITTED }
      let!(:wex_refund) { create(:payment, order: order, account: registration.account, payment_type: Payment::PAYMENT_TYPE_REFUND, govpay_id: "345", payment_status: prior_payment_status) }

      include_examples "Govpay webhook services error logging"

      shared_examples "failed refund update" do
        it { expect { run_service }.to raise_error(ArgumentError) }

        it_behaves_like "logs an error"
      end

      context "when the update is not for a refund" do
        before { webhook_body.delete("refund_id") }

        it_behaves_like "failed refund update"
      end

      context "when the update is for a refund" do
        context "when status is not present in the update" do
          before { webhook_body["status"] = nil }

          it_behaves_like "failed refund update"
        end

        context "when status is present in the update" do
          context "when the refund is not found" do
            before do
              wex_refund.destroy!
            end

            context "when original payment record exists" do
              it "creates a new refund payment" do
                expect { run_service }.to change(Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND), :count).by(1)
              end

              it "creates a refund with correct attributes" do
                run_service
                new_refund = Payment.last

                aggregate_failures do
                  expect(new_refund.payment_type).to eq(Payment::PAYMENT_TYPE_REFUND)
                  expect(new_refund.payment_amount).to eq(0 - webhook_body["amount"])
                  expect(new_refund.payment_status).to eq(Payment::PAYMENT_STATUS_SUCCESS)
                  expect(new_refund.account_id).to eq(wex_original_payment.account_id)
                  expect(new_refund.payment_uuid).to be_present
                  expect(new_refund.govpay_id).to eq(govpay_refund_id)
                  expect(new_refund.associated_payment).to eq(wex_original_payment)
                end
              end
            end

            context "when original payment record does not exist" do
              before do
                wex_original_payment.destroy!
              end

              it_behaves_like "failed refund update"
            end
          end

          context "when the refund is found" do
            context "when the refund status has not changed" do
              let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUCCESS }

              it { expect { run_service }.not_to change(wex_original_payment, :payment_status) }

              it "writes a warning to the Rails log" do
                run_service

                expect(Rails.logger).to have_received(:warn)
              end
            end

            context "when the refund status has changed" do
              let(:wex_payment) { wex_refund } # shared example expects wex_payment object

              include_examples "Govpay webhook status transitions"

              # unfinished statuses
              it_behaves_like "valid and invalid transitions", Payment::PAYMENT_STATUS_SUBMITTED, %w[success], %w[error]

              # finished statuses
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_SUCCESS
              it_behaves_like "no valid transitions", "error"

              # There are no valid transitions other than to success other than to success.
              # context "when the webhook changes the status to a non-success value" do

              context "when the webhook changes the status to success" do
                let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUBMITTED }

                before { assign_webhook_status("success") }

                it "updates the balance" do
                  expect { run_service }.to change { registration.account.reload.balance }
                end
              end
            end
          end
        end
      end
    end

    # used by shared examples - different for payment vs refund webhooks
    def assign_webhook_status(status)
      webhook_body["status"] = status
    end
  end
end
