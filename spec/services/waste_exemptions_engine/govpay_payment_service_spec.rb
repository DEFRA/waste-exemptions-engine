# frozen_string_literal: true

# require "webmock/rspec"
require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayPaymentService do
    let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }
    let(:order) { build(:order, :with_charge_detail) }
    let(:payment) { build(:payment, order: order) }
    let(:transient_registration) { create(:new_charged_registration, order: order) }
    let(:govpay_service) { described_class.new(transient_registration, transient_registration.order) }

    before do
      allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)

      stub_request(:any, /.*#{govpay_host}.*/).to_return(
        status: 200,
        body: File.read("./spec/fixtures/files/govpay/create_payment_created_response.json")
      )
    end

    describe "prepare_for_payment" do
      let(:defra_ruby_govpay_api) { DefraRubyGovpay::API.new(host_is_back_office:) }
      let(:host_is_back_office) { WasteExemptionsEngine.configuration.host_is_back_office? }
      let(:placeholder_registration) { create(:registration, lifecycle_status: "placeholder", account: build(:account)) }

      before do
        allow(DefraRubyGovpay::API).to receive(:new).and_return(defra_ruby_govpay_api)
        allow(defra_ruby_govpay_api).to receive(:send_request).with(anything).and_call_original

        transient_registration.reference = placeholder_registration.reference
      end

      context "when the request is valid" do
        it "returns a link" do
          url = govpay_service.prepare_for_payment[:url]
          # expect the value from the payment response file fixture
          expect(url).to eq("https://www.payments.service.gov.uk/secure/bb0a272c-8eaf-468d-b3xf-ae5e000d2231")
        end

        it "does not change payment status" do
          expect { govpay_service.prepare_for_payment }.not_to change(payment, :payment_status)
        end

        it "creates a payment with expected attributes" do
          response = govpay_service.prepare_for_payment

          aggregate_failures do
            expect(response[:payment].payment_type).to eq(Payment::PAYMENT_TYPE_GOVPAY)
            expect(response[:payment].payment_amount).to eq(order.total_charge_amount)
            expect(response[:payment].payment_status).to eq(Payment::PAYMENT_STATUS_CREATED)
            expect(response[:payment].date_time.to_s).to include(Date.today.to_s)
            expect(response[:payment].govpay_id).to be_present
            expect(response[:payment].payment_uuid).to be_present
          end
        end

        context "when the request is from the back-office" do
          before do
            allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(true)
            allow(defra_ruby_govpay_api).to receive(:send_request).with(anything).and_call_original
          end

          it "sends the moto flag to GovPay" do
            govpay_service.prepare_for_payment

            expect(defra_ruby_govpay_api).to have_received(:send_request).with(
              is_moto: true,
              method: :post,
              path: anything,
              params: hash_including(moto: true)
            )
          end
        end

        context "when the request is from the front-office" do
          before { allow(WasteExemptionsEngine.configuration).to receive(:host_is_back_office?).and_return(false) }

          it "does not send the moto flag to GovPay" do
            govpay_service.prepare_for_payment

            expect(defra_ruby_govpay_api).to have_received(:send_request).with(
              is_moto: false,
              method: :post,
              path: anything,
              params: hash_not_including(moto: true)
            )
          end
        end
      end

      context "when the request is invalid" do
        before do
          stub_request(:any, /.*#{govpay_host}.*/).to_return(
            status: 200,
            body: File.read("./spec/fixtures/files/govpay/create_payment_error_response.json")
          )
        end

        it "returns :error" do
          expect(govpay_service.prepare_for_payment).to eq(:error)
        end
      end
    end

    describe "#payment_callback_url" do
      let(:callback_host) { Faker::Internet.url }

      before { allow(Rails.configuration).to receive(:front_office_url).and_return(callback_host) }

      context "when the payment does not exist" do
        let(:payment) { nil }

        subject(:callback_url) { govpay_service.payment_callback_url(payment) }

        it "raises an exception" do
          expect { callback_url }.to raise_error(StandardError)
        end
      end

      context "when the payment exists" do
        subject(:callback_url) { govpay_service.payment_callback_url(payment) }

        it "the callback url includes the base path" do
          expect(callback_url).to start_with(callback_host)
        end

        it "the callback url includes the payment uuid" do
          expect(callback_url).to include(payment.payment_uuid)
        end
      end
    end
  end
end
