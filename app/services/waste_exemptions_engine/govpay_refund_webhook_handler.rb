# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayRefundWebhookHandler < BaseService
    attr_accessor :govpay_payment_id

    def run(govpay_webhook_body)
      @webhook_body = govpay_webhook_body&.deep_symbolize_keys

      @govpay_payment_id = webhook_body[:resource_id]

      find_refund
      previous_status = @refund&.payment_status

      result = DefraRubyGovpay::WebhookRefundService.run(
        webhook_body, previous_status: previous_status
      )

      refund_govpay_id, payment_govpay_id, status = result.values_at(:id, :payment_id, :status)

      find_registration
      update_refund_status_and_reference(status)

      Rails.logger.info "Updated status from #{previous_status} to #{status} for refund #{refund_govpay_id}, " \
                        "payment #{payment_govpay_id}, registration #{@registration.reference}"

      result
    rescue StandardError => e
      msg = "Error processing webhook for refund #{refund_govpay_id}, payment #{payment_govpay_id}, status #{status}"
      Rails.logger.error "#{msg}: #{e}"
      Airbrake.notify msg, e
      raise
    end

    private

    attr_accessor :webhook_body, :refund, :registration

    def find_refund
      payment = Payment.find_by(govpay_id: govpay_payment_id)
      handle_payment_not_found unless payment.present?

      @refund = Payment.find_by(
        payment_type: Payment::PAYMENT_TYPE_REFUND,
        refunded_payment_govpay_id: govpay_payment_id
      )
      handle_refund_not_found unless @refund.present?
      @refund
    end

    def update_refund_status_and_reference(status)
      @refund.update(payment_status: status, reference: @refund.payment_uuid)
    end

    def find_registration
      @registration = @refund&.account&.registration
      handle_registration_not_found unless @registration.present?
      @registration
    end

    def handle_payment_not_found
      Rails.logger.error "Govpay payment not found for govpay_id #{govpay_payment_id}"
      Airbrake.notify "Govpay payment not found for govpay_id #{govpay_payment_id}"
      raise ArgumentError, "payment not found"
    end

    def handle_refund_not_found
      # create refund record if it doesn't exist
      @refund = GovpayWebhookRefundCreator.run(govpay_webhook_body: webhook_body)
    rescue StandardError
      Rails.logger.error "Govpay refund not found for govpay_id #{webhook_body[:govpay_id]}"
      Airbrake.notify "Govpay refund not found for govpay_id #{webhook_body[:govpay_id]}"
      raise ArgumentError, "refund not found"
    end

    def handle_registration_not_found
      Rails.logger.error "Govpay registration not found for govpay_id #{webhook_body[:govpay_id]}"
      Airbrake.notify "Govpay registration not found for govpay_id #{webhook_body[:govpay_id]}"
      raise ArgumentError, "registration not found"
    end
  end
end
