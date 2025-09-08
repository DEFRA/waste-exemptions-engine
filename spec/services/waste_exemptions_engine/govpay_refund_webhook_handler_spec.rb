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

      let(:prior_refund_status) { Payment::PAYMENT_STATUS_SUBMITTED }
      let!(:wex_refund) do
        create(:payment,
               order: order,
               account: registration.account,
               payment_type: Payment::PAYMENT_TYPE_REFUND,
               #  govpay_id: "345",
               refunded_payment_govpay_id: wex_original_payment.govpay_id,
               payment_status: prior_refund_status)
      end

      before do
        webhook_body["resource_id"] = wex_original_payment.govpay_id
        webhook_body["resource"]["payment_id"] = wex_original_payment.govpay_id
      end

      it_behaves_like "Govpay webhook services error logging"

      shared_examples "failed refund update" do
        it { expect { run_service }.to raise_error(ArgumentError) }

        it_behaves_like "logs an error"
      end

      shared_examples "an invalid refund status transition" do |old_status, new_status|
        before do
          wex_refund.update(payment_status: old_status)
          assign_webhook_status(new_status)
        end

        it "does not update the status from #{old_status} to #{new_status}" do
          expect { run_service }.not_to(change { wex_payment.reload.payment_status })
        rescue DefraRubyGovpay::WebhookBaseService::InvalidStatusTransition
          # expected exception
        end

        it "logs an error when attempting to update status from #{old_status} to #{new_status}" do
          run_service

          expect(Airbrake).to have_received(:notify)
        rescue DefraRubyGovpay::WebhookBaseService::InvalidStatusTransition
          # expected exception
        end
      end

      shared_examples "no valid refund status transitions" do |old_status|
        (%w[created started submitted success failed cancelled error] - [old_status]).each do |new_status|
          it_behaves_like "an invalid refund status transition", old_status, new_status
        end
      end

      context "when the update is not for a refund" do
        before { webhook_body["event_type"] = "card_payment_succeeded" }

        it_behaves_like "failed refund update"
      end

      context "when the update is for a refund" do
        context "when status is not present in the update" do
          before { webhook_body["resource"]["state"]["status"] = nil }

          it_behaves_like "failed refund update"
        end

        context "when status is present in the update" do
          before do
            WasteExemptionsEngine::Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND)
                                          .last
                                          .update(payment_status: prior_refund_status)
          end

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
                  expect(new_refund.payment_type).to eq Payment::PAYMENT_TYPE_REFUND
                  expect(new_refund.payment_amount).to eq 0 - webhook_body["resource"]["amount"].to_i
                  expect(new_refund.payment_status).to eq Payment::PAYMENT_STATUS_SUCCESS
                  expect(new_refund.account_id).to eq wex_original_payment.account_id
                  expect(new_refund.payment_uuid).to be_present
                  expect(new_refund.associated_payment).to eq wex_original_payment
                  expect(new_refund.refunded_payment_govpay_id).to eq wex_original_payment.govpay_id
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
              let(:prior_refund_status) { Payment::PAYMENT_STATUS_SUCCESS }

              before { allow(Rails.logger).to receive(:warn) }

              it { expect { run_service }.not_to change(wex_original_payment, :payment_status) }

              it "writes a warning to the Rails log" do
                run_service

                expect(Rails.logger).to have_received(:warn)
              end
            end

            context "when the refund status has changed" do
              let(:wex_payment) { wex_refund } # shared example expects wex_payment object

              # unfinished statuses
              it_behaves_like "a valid payment status transition", Payment::PAYMENT_STATUS_SUBMITTED, Payment::PAYMENT_STATUS_SUCCESS
              it_behaves_like "a valid payment status transition", Payment::PAYMENT_STATUS_SUBMITTED, Payment::PAYMENT_STATUS_ERROR

              # finished statuses
              it_behaves_like "no valid refund status transitions", Payment::PAYMENT_STATUS_SUCCESS
              it_behaves_like "no valid refund status transitions", Payment::PAYMENT_STATUS_ERROR

              context "when the webhook changes the status to success" do
                let(:prior_refund_status) { Payment::PAYMENT_STATUS_SUBMITTED }

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
  end
end
