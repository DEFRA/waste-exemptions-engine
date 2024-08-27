# frozen_string_literal: true

require "webmock/rspec"
require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayCallbackService do
    let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
    let(:govpay_callback_service) { described_class.new(payment.payment_uuid) }
    let(:govpay_payment_details_service) { instance_double(GovpayPaymentDetailsService) }

    let(:transient_registration) { create(:new_charged_registration) }
    let(:order) { create(:order, order_owner: transient_registration) }
    let(:payment) { create(:payment, order: order) }

    before do
      allow(GovpayPaymentDetailsService).to receive(:new).and_return(govpay_payment_details_service)

      allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)

      payment.update(govpay_id: "a_govpay_id")
    end

    describe "#payment_callback" do

      before { allow(govpay_payment_details_service).to receive(:govpay_payment_status).and_return("created") }

      context "when the status is valid" do
        it "returns true" do
          expect(govpay_callback_service.valid_success?).to be true
        end

        it "updates the payment status" do
          govpay_callback_service.valid_success?
          expect(payment.reload.payment_status).to eq("success")
        end

        context "when run in the front office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false) }

          it "calls the GovpayPaymentDetailsService with is_moto: false" do
            govpay_callback_service.valid_success?
            expect(GovpayPaymentDetailsService).to have_received(:new).with(hash_not_including(is_moto: true))
          end
        end

        context "when run in the back office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true) }

          it "calls the GovpayPaymentDetailsService with is_moto: true" do
            govpay_callback_service.valid_success?
            expect(GovpayPaymentDetailsService).to have_received(:new).with(hash_including(is_moto: true))
          end
        end

        context "when a new order is initiated before the first one is completed" do
          it { expect(govpay_callback_service.valid_success?).to be true }
        end
      end

      context "when the status is invalid" do
        let(:govpay_callback_service) { described_class.new("invalid_uuid") }

        it "returns false" do
          expect(govpay_callback_service.valid_success?).to be false
        end

        it "does not update the order" do
          unmodified_order = transient_registration.order
          govpay_callback_service.valid_success?
          expect(transient_registration.reload.order).to eq(unmodified_order)
        end

        it "does not update payment status" do
          expect { govpay_callback_service.valid_success? }.not_to change(payment, :payment_status)
        end
      end
    end
  end
end
