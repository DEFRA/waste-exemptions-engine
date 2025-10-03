# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayRefundWebhookHandler < BaseService
    attr_accessor :govpay_payment_id, :webhook_body, :registration, :refund

    def run(govpay_webhook_body)
      @webhook_body = govpay_webhook_body&.deep_symbolize_keys

      @govpay_payment_id = webhook_body[:resource_id]

      unless refundable
        Rails.logger.warn "Webhook refund amount #{webhook_refund_amount} exceeds maximum " \
                          "refundable amount #{max_refundable} on payment #{payment.govpay_id}"
        return
      end

      @registration = find_registration

      result = DefraRubyGovpay::WebhookRefundService.run(webhook_body)

      create_refund

      Rails.logger.info "Recorded refund #{refund.id}, amount #{webhook_body[:resource][:amount]} for " \
                        "payment #{govpay_payment_id}, registration #{registration.reference}"

      result
    rescue StandardError => e
      msg = "Error processing refund webhook for payment #{govpay_payment_id}"
      Rails.logger.error "#{msg}: #{e}"
      Airbrake.notify msg, e
      raise
    end

    private

    def payment
      @payment ||= Payment.find_by(
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        govpay_id: govpay_payment_id
      ) || handle_payment_not_found
    end

    def find_registration
      @registration = payment&.account&.registration
      handle_registration_not_found unless @registration.present?
      @registration
    end

    def handle_payment_not_found
      Rails.logger.error "Govpay payment not found for govpay_id #{govpay_payment_id}"
      Airbrake.notify "Govpay payment not found for govpay_id #{govpay_payment_id}"
      raise ArgumentError, "payment not found"
    end

    def webhook_refund_amount
      @webhook_refund_amount ||= webhook_body.dig(:resource, :refund_summary, :amount_submitted)
    end

    def max_refundable
      @max_refundable ||= payment.payment_amount -
                          Payment.where(payment_type: Payment::PAYMENT_TYPE_REFUND,
                                        refunded_payment_govpay_id: payment.govpay_id)
                                 .sum(&:payment_amount)
    end

    def refundable
      @refundable ||= webhook_refund_amount < max_refundable
    end

    def create_refund
      @refund = GovpayWebhookRefundCreator.run(govpay_webhook_body: webhook_body)
    rescue StandardError
      message = "Govpay payment not found for govpay_id #{webhook_body[:resource_id]}"
      Rails.logger.error message
      Airbrake.notify message
      raise ArgumentError, message
    end

    def handle_registration_not_found
      message = "Registration not found for payment with govpay_id #{webhook_body[:resource_id]}"
      Rails.logger.error message
      Airbrake.notify message
      raise ArgumentError, message
    end
  end
end
