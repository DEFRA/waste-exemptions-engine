# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayRefundWebhookHandler
    def self.process(webhook_body)
      refund_govpay_id = webhook_body["refund_id"]
      refund = refund_by_govpay_id(refund_govpay_id)

      previous_status = refund&.payment_status

      result = DefraRubyGovpay::WebhookRefundService.run(
        webhook_body,
        previous_status: previous_status
      )

      refund_govpay_id, payment_govpay_id, status = result.values_at(:id, :payment_id, :status)

      return if refund.blank?

      registration = registration_by_govpay_id(refund_govpay_id)
      return if registration.blank?

      update_refund_status_and_reference(refund, status)

      Rails.logger.info "Updated status from #{previous_status} to #{status} for refund #{refund_govpay_id}, " \
                        "payment #{payment_govpay_id}, registration #{registration.reference}"
    rescue StandardError => e
      Rails.logger.error "Error processing webhook for refund #{refund_govpay_id}, payment #{payment_govpay_id}: #{e}"
      Airbrake.notify "Error processing webhook for refund #{refund_govpay_id}, payment #{payment_govpay_id}", e
      raise
    end

    def self.update_refund_status_and_reference(refund, status)
      refund.update(payment_status: status, reference: refund.payment_uuid)
    end

    def self.registration_by_govpay_id(govpay_id)
      refund_by_govpay_id(govpay_id)&.account&.registration
    end

    def self.refund_by_govpay_id(govpay_id)
      payment = Payment.find_by(payment_type: Payment::PAYMENT_TYPE_REFUND, govpay_id: govpay_id)
      payment || handle_payment_not_found(govpay_id)
    end

    def self.handle_payment_not_found(govpay_id)
      Rails.logger.error "Govpay payment not found for govpay_id #{govpay_id}"
      Airbrake.notify "Govpay payment not found for govpay_id #{govpay_id}"
      raise ArgumentError, "invalid govpay_id"
    end
  end
end
