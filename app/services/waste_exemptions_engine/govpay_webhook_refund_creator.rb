# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayWebhookRefundCreator < BaseService
    def run(govpay_webhook_body:)
      @govpay_webhook_body = govpay_webhook_body&.deep_symbolize_keys
      # @todo: this can be moved to DefraRubyGovpay gem at a later stage
      GovpayRefundWebhookHandler.validate_refund_webhook_body_attributes(@govpay_webhook_body)

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
        govpay_id: govpay_webhook_body[:payment_id]
      )
      original_payment || handle_payment_not_found
    end

    def handle_payment_not_found
      Rails.logger.error "Govpay payment not found for govpay_id #{govpay_webhook_body[:payment_id]}"
      Airbrake.notify "Govpay payment not found for govpay_id #{govpay_webhook_body[:payment_id]}"
      raise ArgumentError, "invalid govpay_id"
    end

    def build_refund(payment)
      Payment.new(
        payment_type: Payment::PAYMENT_TYPE_REFUND,
        payment_amount: 0 - govpay_webhook_body[:amount].to_i,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        account_id: payment.account_id,
        reference: "#{payment.reference}/REFUND",
        payment_uuid: SecureRandom.uuid,
        govpay_id: govpay_webhook_body[:refund_id],
        comments: "govpay refund",
        associated_payment: payment
      )
    end
  end
end
