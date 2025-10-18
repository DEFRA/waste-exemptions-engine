# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayRefundWebhookHandler < BaseService
    attr_accessor :govpay_payment_id, :webhook_body, :refund

    def run(govpay_webhook_body)
      @webhook_body = govpay_webhook_body&.deep_symbolize_keys

      @govpay_payment_id = webhook_body[:resource_id]

      unless max_refundable.positive?
        Rails.logger.warn "Webhook refund amount #{webhook_refund_amount} exceeds maximum " \
                          "refundable amount #{max_refundable} on payment #{@original_payment.govpay_id}"
        return
      end

      result = DefraRubyGovpay::WebhookRefundService.run(webhook_body)

      create_refund

      Rails.logger.info "Recorded refund #{refund.id}, amount #{refunded_amount} for " \
                        "payment #{govpay_payment_id}, registration #{registration.reference}"

      result
    rescue StandardError => e
      msg = "Error processing refund webhook for payment #{govpay_payment_id}"
      Rails.logger.error "#{msg}: #{e}"
      Airbrake.notify msg, e
      raise
    end

    private

    def original_payment
      @original_payment ||= Payment.find_by(
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        govpay_id: govpay_payment_id
      ) || handle_payment_not_found
    end

    def registration
      @registration ||= original_payment&.account&.registration
    end

    def handle_payment_not_found
      message = "Govpay payment not found for govpay_id #{govpay_payment_id}"
      Rails.logger.error message
      Airbrake.notify message
      raise ArgumentError, message
    end

    def webhook_refund_amount
      @webhook_refund_amount ||= webhook_body.dig(:resource, :refund_summary, :amount_submitted)
    end

    def max_refundable
      @max_refundable ||= original_payment.payment_amount -
                          Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND,
                                        refunded_payment_govpay_id: original_payment.govpay_id)
                                 .sum(&:payment_amount)
    end

    def amount_already_refunded
      @amount_already_refunded ||= Payment.where(
        payment_type: Payment::PAYMENT_TYPE_REFUND,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        refunded_payment_govpay_id: govpay_payment_id
      ).sum(&:payment_amount)
    end

    def refunded_amount
      # The amount_submitted from the webhook body minus all refund amounts
      # previously recorded (refund amounts are negative)
      webhook_refund_amount + amount_already_refunded
    end

    def create_refund
      @refund = Payment.create!(
        refunded_payment_govpay_id: original_payment.govpay_id,
        payment_type: Payment::PAYMENT_TYPE_REFUND,
        payment_amount: -refunded_amount,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        account_id: original_payment.account_id,
        reference: "#{original_payment.reference}/REFUND",
        payment_uuid: SecureRandom.uuid,
        comments: "govpay refund",
        associated_payment: original_payment
      )
    end
  end
end
