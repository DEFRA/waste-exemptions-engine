# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe FindGovpayPaymentService do
    describe "#run" do
      subject(:run_service) { described_class.new.run(govpay_payment_id) }

      let(:govpay_payment_id) { SecureRandom.hex(24) }
      let(:original_payment) do
        create(:payment,
               payment_type: Payment::PAYMENT_TYPE_GOVPAY,
               payment_status: Payment::PAYMENT_STATUS_SUCCESS,
               govpay_id: govpay_payment_id)
      end

      before do
        allow(Rails.logger).to receive(:error)
        allow(Airbrake).to receive(:notify)
      end

      shared_examples "handles errors" do
        it "raises ArgumentError" do
          expect { run_service }.to raise_error(ArgumentError, error_message_pattern)
        end

        it "logs the error" do
          run_service

          expect(Rails.logger).to have_received(:error).with(error_message_pattern)
        rescue StandardError
          # expected exception raised
        end

        it "notifies Airbrake" do
          run_service

          expect(Airbrake).to have_received(:notify).with(error_message_pattern)
        rescue StandardError
          # expected exception raised
        end
      end

      context "when the original payment is not found" do
        before { original_payment&.destroy! }

        it_behaves_like "handles errors" do
          let(:error_message_pattern) { /Govpay payment not found.*#{govpay_payment_id}/ }
        end
      end

      context "when the original payment record exists" do
        context "when the original payment is not a govpay payment" do
          before { original_payment.update(payment_type: Payment::PAYMENT_TYPE_BANK_TRANSFER) }

          it_behaves_like "handles errors" do
            let(:error_message_pattern) { /Govpay payment not found.*#{govpay_payment_id}/ }
          end
        end

        context "when the payment was not successful" do
          before { original_payment.update(payment_status: Payment::PAYMENT_STATUS_FAILED) }

          it_behaves_like "handles errors" do
            let(:error_message_pattern) { /Payment status is not success.*#{govpay_payment_id}/ }
          end
        end

        context "when the payment was successful" do
          before { original_payment }

          it "returns the payment" do
            expect(run_service).to eq(original_payment)
          end

          it "does not log any errors" do
            run_service

            expect(Rails.logger).not_to have_received(:error)
          end

          it "does not notify Airbrake" do
            run_service

            expect(Airbrake).not_to have_received(:notify)
          end
        end
      end
    end
  end
end
