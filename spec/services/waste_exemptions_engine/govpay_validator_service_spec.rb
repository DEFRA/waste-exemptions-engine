# frozen_string_literal: true

require "rails_helper"

module WasteExemptionsEngine
  RSpec.describe GovpayValidatorService do
    let(:transient_registration) { create(:new_charged_registration) }
    let(:order) { build(:order, order_owner: transient_registration) }
    let(:payment) { build(:payment, order: order) }
    let(:govpay_validator_service) { described_class.new(order, order&.order_uuid, govpay_status) }
    let(:govpay_host) { "https://publicapi.payments.service.gov.uk" }

    before do
      allow(Rails.configuration).to receive(:govpay_url).and_return(govpay_host)
    end

    shared_examples "valid and invalid Govpay status" do |method, valid_status, invalid_status|
      context "when the payment status is valid" do
        let(:govpay_status) { valid_status }

        it "returns true" do
          expect(govpay_validator_service.public_send(method)).to be true
        end
      end

      context "when the payment status is invalid" do
        let(:govpay_status) { invalid_status }

        it "returns false" do
          expect(govpay_validator_service.public_send(method)).to be false
        end
      end
    end

    describe "valid_success?" do
      let(:govpay_status) { "success" }

      context "when the govpay status is valid" do

        it "returns true" do
          expect(govpay_validator_service.valid_success?).to be true
        end
      end

      context "when the govpay status is not valid" do

        let(:govpay_status) { "failed" }

        it "returns false" do
          expect(govpay_validator_service.valid_success?).to be false
        end
      end

      context "when the order is not present" do
        let(:order) { nil }

        it "returns false" do
          expect(govpay_validator_service.valid_success?).to be false
        end
      end

      context "when the payment_uuid is not present" do
        let(:govpay_validator_service) { described_class.new(order, nil, govpay_status) }

        it "returns false" do
          expect(govpay_validator_service.valid_success?).to be false
        end
      end

      context "when the payment_uuid is invalid" do
        let(:govpay_validator_service) { described_class.new(order, "bad_payment_uuid", govpay_status) }

        it "returns false" do
          expect(govpay_validator_service.valid_success?).to be false
        end
      end
    end

    describe "valid_failure?" do
      it_behaves_like "valid and invalid Govpay status", "valid_failure?", "failed"
    end

    describe "valid_pending?" do
      it_behaves_like "valid and invalid Govpay status", "valid_pending?", "created"
    end

    describe "valid_cancel?" do
      it_behaves_like "valid and invalid Govpay status", "valid_cancel?", "cancelled"
    end

    describe "valid_error?" do
      it_behaves_like "valid and invalid Govpay status", "valid_error?", "error"
    end

    describe "valid_govpay_status?" do
      it "returns true when the status matches the values for the response type" do
        expect(described_class.valid_govpay_status?(:success, "success")).to be true
      end

      it "returns false when the status does not match the values for the response type" do
        expect(described_class.valid_govpay_status?(:success, "FOO")).to be false
      end
    end
  end
end
