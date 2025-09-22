# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayWebhookRefundCreator < BaseService
    attr_accessor :govpay_payment_id

    def run(govpay_webhook_body:)
      raise ArgumentError, "Missing webhook body" unless govpay_webhook_body.present?

      @govpay_webhook_body = govpay_webhook_body&.deep_symbolize_keys

      # Validate the refund webhook
      DefraRubyGovpay::WebhookRefundService.run(@govpay_webhook_body)

      @govpay_payment_id = @govpay_webhook_body[:resource_id]
      original_payment = find_payment
      refund = build_refund(original_payment)
      refund.save!

      refund
    rescue StandardError => e
      Rails.logger.error "#{e.class} error processing GovPay request #{govpay_webhook_body} - #{e.message}"
      Airbrake.notify(e, message: "Error processing GovPay request ", govpay_webhook_body: govpay_webhook_body)
      raise
    end

    private

    attr_accessor :govpay_webhook_body

    def find_payment
      original_payment = Payment.find_by(
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        govpay_id: govpay_payment_id
      )
      original_payment || handle_payment_not_found
    end

    def handle_payment_not_found
      Rails.logger.error "Govpay payment not found for govpay_id #{govpay_payment_id}"
      Airbrake.notify "Govpay payment not found for govpay_id #{govpay_payment_id}"
      raise ArgumentError, "invalid govpay_id"
    end

    def build_refund(payment)
      Payment.new(
        refunded_payment_govpay_id: payment.govpay_id,
        payment_type: Payment::PAYMENT_TYPE_REFUND,
        payment_amount: 0 - govpay_webhook_body.dig(:resource, :amount).to_i,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        account_id: payment.account_id,
        reference: "#{payment.reference}/REFUND",
        payment_uuid: SecureRandom.uuid,
        comments: "govpay refund",
        associated_payment: payment
      )
    end
  end
end
