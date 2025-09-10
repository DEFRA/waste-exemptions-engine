# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayPaymentWebhookHandler do
    describe ".process" do

      subject(:run_service) { described_class.new.process(webhook_body) }

      let(:webhook_body) { JSON.parse(file_fixture("govpay/webhook_payment_update_body.json").read) }
      let(:webhook_resource) { webhook_body["resource"] }
      let(:govpay_payment_id) { webhook_body["resource"]["payment_id"] }
      let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUBMITTED }

      let(:registration) { create(:registration, :complete, account: build(:account)) }
      let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }

      let!(:wex_payment) do
        create(:payment,
               order: order,
               account: registration.account,
               govpay_id: "hu20sqlact5260q2nanm0q8u93",
               payment_status: prior_payment_status)
      end

      before do
        allow(Rails.logger).to receive(:warn)
        allow(Rails.logger).to receive(:error)
      end

      shared_examples "an invalid payment status transition" do |old_status, new_status|
        before do
          WasteExemptionsEngine::Payment.find_by(govpay_id: govpay_payment_id).update(payment_status: old_status)
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

      shared_examples "no valid transitions" do |old_status|
        (%w[created started submitted success failed cancelled error] - [old_status]).each do |new_status|

          it_behaves_like "an invalid payment status transition", old_status, new_status
        end
      end

      context "when the update is not for a payment" do
        before { webhook_body["resource_type"] = "refund" }

        it_behaves_like "logs an error"

        it "raises the expected exception" do
          expect { run_service }.to raise_error(ArgumentError, /Invalid webhook type refund/)
        end
      end

      context "when the update is for a payment" do
        context "when status is not present in the update" do
          before { assign_webhook_status(nil) }

          it { expect { run_service }.to raise_error(ArgumentError) }

          it_behaves_like "logs an error"
        end

        shared_examples "status is present in the update" do
          context "when the payment is not found" do
            before do
              webhook_body["resource_id"] = "foo"
              allow(Airbrake).to receive(:notify)
            end

            it { expect { run_service }.to raise_error(ArgumentError) }

            it_behaves_like "logs an error"

            it "notifies Airbrake with correct parameters" do
              begin
                run_service
              rescue ArgumentError
                # Expected error
              end

              expect(Airbrake).to have_received(:notify).with(
                "Govpay payment not found for govpay_id foo"
              )
            end
          end

          context "when the payment is found" do
            context "when the payment status has not changed" do
              let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUCCESS }

              it { expect { run_service }.not_to change(wex_payment, :payment_status) }

              it "writes a warning to the Rails log" do
                run_service

                expect(Rails.logger).to have_received(:warn)
              end

              it "sets the payment reference to the payment uuid" do
                run_service

                expect(wex_payment.reload.reference).to eq(wex_payment.payment_uuid)
              end

              it "returns the hash which includes govpay_id and status" do
                response = run_service
                expect(response).to include(id: wex_payment.govpay_id, status: wex_payment.payment_status)
              end
            end

            context "when the payment status has changed" do

              # unfinished statuses

              # created
              %w[started submitted success failed cancelled error].each do |new_status|
                it_behaves_like "a valid payment status transition", Payment::PAYMENT_STATUS_CREATED, new_status
              end

              # started
              %w[submitted success failed cancelled error].each do |new_status|
                it_behaves_like "a valid payment status transition", Payment::PAYMENT_STATUS_STARTED, new_status
              end
              it_behaves_like "an invalid payment status transition", Payment::PAYMENT_STATUS_STARTED, Payment::PAYMENT_STATUS_CREATED

              # submitted
              %w[success failed cancelled error].each do |new_status|
                it_behaves_like "a valid payment status transition", Payment::PAYMENT_STATUS_SUBMITTED, new_status
              end
              it_behaves_like "an invalid payment status transition", Payment::PAYMENT_STATUS_SUBMITTED, %w[started]

              # finished statuses
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_SUCCESS
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_FAILED
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_CANCELLED
              it_behaves_like "no valid transitions", "error"

              describe "InvalidStatusTransition error" do
                let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUCCESS }
                let(:exception) { DefraRubyGovpay::WebhookBaseService::InvalidStatusTransition.new("Invalid payment status transition") }

                before do
                  assign_webhook_status("started")
                  allow(DefraRubyGovpay::WebhookPaymentService).to receive(:run).and_raise(exception)
                  allow(Airbrake).to receive(:notify)
                end

                it "notifies Airbrake with the exception and payment ID" do
                  run_service
                rescue DefraRubyGovpay::WebhookBaseService::InvalidStatusTransition
                  # This is expected
                  expect(Airbrake).to have_received(:notify).with(
                    exception,
                    hash_including(message: "Error processing webhook for payment #{govpay_payment_id}")
                  )
                end
              end

              context "when the webhook changes the status to a non-success value" do
                let(:prior_payment_status) { Payment::PAYMENT_STATUS_STARTED }

                before { assign_webhook_status("cancelled") }

                it "does not update the balance" do
                  expect { run_service }.not_to change { registration.account.reload.balance }
                end
              end

              context "when the webhook changes the status to success" do
                let(:prior_payment_status) { Payment::PAYMENT_STATUS_STARTED }

                before { assign_webhook_status("success") }

                it "updates the balance" do
                  expect { run_service }.to change { registration.account.reload.balance }
                end

                it "sets the payment reference to the payment uuid" do
                  expect { run_service }.to change { wex_payment.reload.reference }.to(wex_payment.payment_uuid)
                end
              end
            end
          end
        end

        context "when the payment belongs to a registration" do
          let(:registration) { create(:registration, :complete, account: build(:account)) }
          let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }

          it_behaves_like "status is present in the update"
        end

        context "when the resource_type has different casings" do
          shared_examples "handles case-insensitive resource_type as payment" do |resource_type_value|

            before { webhook_body["resource_type"] = resource_type_value }

            %w[started submitted success failed cancelled error].each do |new_status|
              it_behaves_like "a valid payment status transition", Payment::PAYMENT_STATUS_CREATED, new_status
            end
          end

          %w[payment PAYMENT].each do |case_variant|
            it_behaves_like "handles case-insensitive resource_type as payment", case_variant
          end
        end
      end
    end
  end
end
