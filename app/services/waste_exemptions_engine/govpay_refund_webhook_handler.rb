# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayRefundWebhookHandler < BaseService
    def run(webhook_body)
      @webhook_body = webhook_body&.deep_symbolize_keys
      validate_webhook_body

      refund = find_refund
      return if refund.blank?

      previous_status = refund&.payment_status

      result = DefraRubyGovpay::WebhookRefundService.run(
        webhook_body, previous_status: previous_status
      )

      refund_govpay_id, payment_govpay_id, status = result.values_at(:id, :payment_id, :status)

      registration = find_registration
      return if registration.blank?

      update_refund_status_and_reference(refund, status)

      Rails.logger.info "Updated status from #{previous_status} to #{status} for refund #{refund_govpay_id}, " \
                        "payment #{payment_govpay_id}, registration #{registration.reference}"

      result
    rescue StandardError => e
      msg = "Error processing webhook for refund #{refund_govpay_id}, payment #{payment_govpay_id}, status #{status}"
      Rails.logger.error "#{msg}: #{e}"
      Airbrake.notify msg, e
      raise
    end

    private

    attr_accessor :webhook_body

    def validate_webhook_body
      raise ArgumentError, "govpay_webhook_body is required" if webhook_body.blank?
      raise ArgumentError, "payment_id is required" unless webhook_body.include?(:payment_id)
      raise ArgumentError, "refund_id is required" unless webhook_body.include?(:refund_id)
      raise ArgumentError, "amount is required" unless webhook_body.include?(:amount)
      raise ArgumentError, "status is required" unless webhook_body.include?(:status)
    end

    def find_refund
      refund = Payment.find_by(
        payment_type: Payment::PAYMENT_TYPE_REFUND,
        govpay_id: webhook_body[:refund_id]
      )
      refund || handle_refund_not_found
    end

    def update_refund_status_and_reference(refund, status)
      refund.update(payment_status: status, reference: refund.payment_uuid)
    end

    def find_registration
      find_refund.account&.registration
    end

    def handle_refund_not_found
      # create refund record if it doesn't exist
      GovpayCreateRefundService.run(govpay_webhook_body: webhook_body)
    rescue StandardError
      Rails.logger.error "Govpay refund not found for govpay_id #{webhook_body[:govpay_id]}"
      Airbrake.notify "Govpay refund not found for govpay_id #{webhook_body[:govpay_id]}"
      raise ArgumentError, "invalid govpay_id"
    end
  end
end
