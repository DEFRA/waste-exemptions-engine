# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayWebhookRefundCreator do
    describe "#run" do
      subject(:run_service) { described_class.new.run(govpay_webhook_body: govpay_webhook_body) }

      let(:account) { create(:account) }
      let(:order) { create(:order, :with_charge_detail, order_owner: account) }
      let(:original_payment) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_GOVPAY,
               payment_status: Payment::PAYMENT_STATUS_SUCCESS,
               payment_amount: 2000,
               govpay_id: govpay_payment_id,
               reference: "WEX123456",
               account: account,
               order: order)
      end

      let(:govpay_webhook_body) { JSON.parse(file_fixture("govpay/webhook_refund_update_body.json").read) }
      let(:govpay_payment_id) { govpay_webhook_body["resource_id"] if govpay_webhook_body.present? }

      before { original_payment }

      context "when the request is valid" do
        it "returns the refund payment" do
          aggregate_failures do
            expect(run_service).to be_a(Payment)
            expect(run_service.payment_type).to eq(Payment::PAYMENT_TYPE_REFUND)
          end
        end

        it "creates a refund payment" do
          expect { run_service }.to change(Payment, :count).by(1)
        end

        it "creates a refund with correct attributes" do
          run_service
          refund = Payment.last

          aggregate_failures do
            expect(refund.refunded_payment_govpay_id).to eq govpay_payment_id
            expect(refund.payment_type).to eq(Payment::PAYMENT_TYPE_REFUND)
            expect(refund.payment_amount).to eq(-47_600)
            expect(refund.payment_status).to eq(Payment::PAYMENT_STATUS_SUCCESS)
            expect(refund.account_id).to eq(account.id)
            expect(refund.reference).to eq("WEX123456/REFUND")
            expect(refund.govpay_id).to be_nil
            expect(refund.associated_payment).to eq(original_payment)
          end
        end

        it "creates a refund with a payment_uuid" do
          run_service
          refund = Payment.last

          aggregate_failures do
            expect(refund.payment_uuid).to be_present
            expect(refund.payment_uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
          end
        end
      end

      context "when validation fails" do
        shared_examples "raises ArgumentError and logs error" do |error_message|
          it "raises ArgumentError" do
            expect { run_service }.to raise_error(ArgumentError, /#{error_message}/)
          end

          it "does not create a refund" do
            expect do

              run_service
            rescue StandardError
              nil
            end.not_to change { Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND).count }
          end

          it "logs the error" do
            allow(Rails.logger).to receive(:error)

            aggregate_failures do
              expect { run_service }.to raise_error(ArgumentError)

              expect(Rails.logger).to have_received(:error).with(/ArgumentError.*#{error_message}/)
            end
          end

          it "notifies Airbrake" do
            allow(Airbrake).to receive(:notify)

            aggregate_failures do
              expect { run_service }.to raise_error(ArgumentError)

              expect(Airbrake).to have_received(:notify).with(
                instance_of(ArgumentError),
                hash_including(message: "Error processing GovPay request ")
              )
            end
          end
        end

        context "when govpay_webhook_body is nil" do
          let(:govpay_webhook_body) { nil }

          it_behaves_like "raises ArgumentError and logs error", "Missing webhook body"
        end

        context "when govpay_webhook_body is empty" do
          let(:govpay_webhook_body) { {} }

          it_behaves_like "raises ArgumentError and logs error", "Missing webhook body"
        end

        context "when resource_id is missing" do
          before { govpay_webhook_body["resource_id"] = nil }

          it_behaves_like "raises ArgumentError and logs error", "Invalid refund webhook"
        end

        context "when status is missing" do
          before { govpay_webhook_body["resource"]["state"]["status"] = nil }

          it_behaves_like "raises ArgumentError and logs error", "Invalid refund webhook"
        end
      end

      context "when the original payment is not found" do
        before { govpay_webhook_body["resource_id"] = "non_existent_payment" }

        it "raises ArgumentError" do
          expect { run_service }.to raise_error(ArgumentError, "invalid govpay_id")
        end

        it "does not create a refund" do
          expect do

            run_service
          rescue StandardError
            nil
          end.not_to change(Payment, :count)
        end

        it "logs the error" do
          allow(Rails.logger).to receive(:error)

          aggregate_failures do
            expect { run_service }.to raise_error(ArgumentError)

            expect(Rails.logger).to have_received(:error).with(/ArgumentError.*invalid govpay_id/)
          end
        end

        it "notifies Airbrake" do
          allow(Airbrake).to receive(:notify)

          aggregate_failures do
            expect { run_service }.to raise_error(ArgumentError)

            expect(Airbrake).to have_received(:notify).with(
              instance_of(ArgumentError),
              hash_including(message: "Error processing GovPay request ")
            )
          end
        end
      end

      context "when the original payment is not a govpay payment" do
        let(:original_payment) do
          create(:payment,
                 payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER,
                 payment_status: Payment::PAYMENT_STATUS_SUCCESS,
                 payment_amount: 2000,
                 reference: "WEX123456",
                 account: account,
                 order: order)
        end

        before { original_payment }

        it { expect { run_service }.to raise_error(ArgumentError) }

        it "logs the error" do
          allow(Rails.logger).to receive(:error)
          aggregate_failures do
            expect { run_service }.to raise_error(ArgumentError)
            expect(Rails.logger).to have_received(:error).with("Govpay payment not found for govpay_id #{govpay_payment_id}")
            expect(Rails.logger).to have_received(:error).with(/ArgumentError.*invalid govpay_id/)
          end
        end
      end

      context "when original payment record exists" do
        context "when the payment is not successful" do
          let(:original_payment) do
            create(:payment,
                   payment_type: Payment::PAYMENT_TYPE_GOVPAY,
                   payment_status: Payment::PAYMENT_STATUS_FAILED,
                   payment_amount: 2000,
                   govpay_id: govpay_payment_id,
                   reference: "WEX123456",
                   account: account,
                   order: order)
          end

          it { expect { run_service }.to raise_error(ArgumentError) }

          it "logs the error" do
            allow(Rails.logger).to receive(:error)
            aggregate_failures do
              expect { run_service }.to raise_error(ArgumentError)
              expect(Rails.logger).to have_received(:error).with("Govpay payment not found for govpay_id #{govpay_payment_id}")
              expect(Rails.logger).to have_received(:error).with(/ArgumentError.*invalid govpay_id/)
            end
          end
        end

        context "when the payment is successful and refund amount is valid" do
          before do
            original_payment # ensure payment exists
          end

          it "returns refund" do
            expect(run_service).to eq(Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND).last)
          end

          it "creates a refund payment" do
            expect { run_service }.to change(Payment, :count).by(1)
          end

          it "creates a refund with correct attributes" do
            run_service
            refund = Payment.last

            aggregate_failures do
              expect(refund.payment_type).to eq(Payment::PAYMENT_TYPE_REFUND)
              expect(refund.payment_amount).to eq(-47_600)
              expect(refund.payment_status).to eq(Payment::PAYMENT_STATUS_SUCCESS)
              expect(refund.account_id).to eq(account.id)
              expect(refund.reference).to eq("WEX123456/REFUND")
              expect(refund.associated_payment).to eq(original_payment)
            end
          end

          it "creates a refund with a payment_uuid" do
            run_service
            refund = Payment.last

            aggregate_failures do
              expect(refund.payment_uuid).to be_present
              expect(refund.payment_uuid).to match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i)
            end
          end

          it "does not log any errors" do
            allow(Rails.logger).to receive(:error)

            run_service

            expect(Rails.logger).not_to have_received(:error)
          end

          it "does not notify Airbrake" do
            allow(Airbrake).to receive(:notify)

            run_service

            expect(Airbrake).not_to have_received(:notify)
          end
        end

        context "when multiple refunds are created for the same payment" do
          before do
            original_payment # ensure payment exists
            # Create an existing refund
            create(:payment,
                   payment_type: Payment::PAYMENT_TYPE_REFUND,
                   payment_status: Payment::PAYMENT_STATUS_SUCCESS,
                   payment_amount: -1000,
                   govpay_id: "previous_refund_123",
                   reference: "WEX123456/REFUND",
                   account: account,
                   associated_payment: original_payment)
          end

          it "still creates a new refund" do
            expect { run_service }.to change(Payment, :count).by(1)
          end

          it "associates the new refund with the original payment" do
            run_service
            refund = Payment.last

            aggregate_failures do
              expect(refund.associated_payment).to eq(original_payment)
              expect(refund.refunded_payment_govpay_id).to eq(original_payment.govpay_id)
            end
          end
        end
      end

      context "when saving the refund fails" do
        before do
          original_payment # ensure payment exists
          payment_double = instance_double(Payment)
          allow(Payment).to receive(:new).and_return(payment_double)
          allow(payment_double).to receive(:save!).and_raise(ActiveRecord::RecordInvalid)
        end

        it "raises ActiveRecord::RecordInvalid" do
          expect { run_service }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it "does not create a refund" do
          expect do

            run_service
          rescue StandardError
            nil
          end.not_to change { Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND).count }
        end

        it "logs the error" do
          allow(Rails.logger).to receive(:error)

          aggregate_failures do
            expect { run_service }.to raise_error(ActiveRecord::RecordInvalid)

            expect(Rails.logger).to have_received(:error).with(/ActiveRecord::RecordInvalid.*processing GovPay request/)
          end
        end

        it "notifies Airbrake" do
          allow(Airbrake).to receive(:notify)

          aggregate_failures do
            expect { run_service }.to raise_error(ActiveRecord::RecordInvalid)

            expect(Airbrake).to have_received(:notify).with(
              instance_of(ActiveRecord::RecordInvalid),
              hash_including(message: "Error processing GovPay request ")
            )
          end
        end
      end

      context "when an unexpected error occurs" do
        before do
          original_payment # ensure payment exists
          allow(SecureRandom).to receive(:uuid).and_raise(StandardError, "Unexpected error")
        end

        it "raises StandardError" do
          expect { run_service }.to raise_error(StandardError, "Unexpected error")
        end

        it "logs the error" do
          allow(Rails.logger).to receive(:error)

          aggregate_failures do
            expect { run_service }.to raise_error(StandardError)

            expect(Rails.logger).to have_received(:error).with(/StandardError.*Unexpected error/)
          end
        end

        it "notifies Airbrake" do
          allow(Airbrake).to receive(:notify)

          aggregate_failures do
            expect { run_service }.to raise_error(StandardError)

            expect(Airbrake).to have_received(:notify).with(
              instance_of(StandardError),
              hash_including(message: "Error processing GovPay request ")
            )
          end
        end
      end
    end
  end
end
