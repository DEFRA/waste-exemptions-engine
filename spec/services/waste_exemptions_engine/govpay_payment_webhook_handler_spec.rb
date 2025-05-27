# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayPaymentWebhookHandler do
    describe ".process" do

      subject(:run_service) { described_class.process(webhook_body) }

      let(:webhook_body) { JSON.parse(file_fixture("govpay/webhook_payment_update_body.json").read) }
      let(:webhook_resource) { webhook_body["resource"] }
      let(:govpay_payment_id) { webhook_body["resource"]["payment_id"] }
      let(:prior_payment_status) { Payment::PAYMENT_STATUS_SUBMITTED }

      let(:registration) { create(:registration, :complete, account: build(:account)) }
      let(:order) { create(:order, :with_charge_detail, order_owner: registration.account) }

      let!(:wex_payment) { create(:payment, order: order, account: registration.account, govpay_id: "hu20sqlact5260q2nanm0q8u93", payment_status: prior_payment_status) }

      include_examples "Govpay webhook services error logging"

      context "when the update is not for a payment" do
        before { webhook_body["resource_type"] = "refund" }

        it { expect { run_service }.to raise_error(ArgumentError) }

        it_behaves_like "logs an error"
      end

      context "when the update is for a payment" do
        context "when status is not present in the update" do
          before { assign_webhook_status(nil) }

          it { expect { run_service }.to raise_error(ArgumentError) }

          it_behaves_like "logs an error"
        end

        shared_examples "status is present in the update" do
          context "when the payment is not found" do
            before { webhook_resource["payment_id"] = "foo" }

            it { expect { run_service }.to raise_error(ArgumentError) }

            it_behaves_like "logs an error"
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

              include_examples "Govpay webhook status transitions"

              # unfinished statuses
              it_behaves_like "valid and invalid transitions", Payment::PAYMENT_STATUS_CREATED, %w[started submitted success failed cancelled error], %w[]
              it_behaves_like "valid and invalid transitions", Payment::PAYMENT_STATUS_STARTED, %w[submitted success failed cancelled error], %w[created]
              it_behaves_like "valid and invalid transitions", Payment::PAYMENT_STATUS_SUBMITTED, %w[success failed cancelled error], %w[started]

              # finished statuses
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_SUCCESS
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_FAILED
              it_behaves_like "no valid transitions", Payment::PAYMENT_STATUS_CANCELLED
              it_behaves_like "no valid transitions", "error"

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
          include_examples "Govpay webhook status transitions"

          shared_examples "handles case-insensitive resource_type as payment" do |resource_type_value|
            before do
              webhook_body["resource_type"] = resource_type_value
            end

            it_behaves_like "valid and invalid transitions", Payment::PAYMENT_STATUS_CREATED, %w[started submitted success failed cancelled error], %w[]
          end

          %w[payment PAYMENT].each do |case_variant|
            it_behaves_like "handles case-insensitive resource_type as payment", case_variant
          end
        end
      end

      # used above and by shared examples - different for payment vs refund webhooks
      def assign_webhook_status(status)
        webhook_body["resource"]["state"]["status"] = status
      end
    end
  end
end
