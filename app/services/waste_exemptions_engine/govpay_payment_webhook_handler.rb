# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayPaymentWebhookHandler
    attr_reader :govpay_payment_id

    def self.process(govpay_webhook_body)
      @webhook_body = govpay_webhook_body&.deep_symbolize_keys
      @govpay_payment_id = @webhook_body[:resource_id]
      payment = payment_by_govpay_id

      previous_status = payment&.payment_status

      result = DefraRubyGovpay::WebhookPaymentService.run(
        @webhook_body,
        previous_status: previous_status
      )
      status = result[:status]

      return if payment.blank?

      registration = registration_by_govpay_id
      return if registration.blank?

      update_payment_status_and_reference(registration, payment, status)

      Rails.logger.info "Updated status from #{previous_status} to #{status} for payment #{@govpay_payment_id}, " \
                        "registration #{registration.reference}"

      result
    rescue StandardError => e
      Rails.logger.error "Error processing webhook for payment #{@govpay_payment_id}: #{e}"
      Airbrake.notify(e, { message: "Error processing webhook for payment #{@govpay_payment_id}" })
      raise
    end

    def self.update_payment_status_and_reference(registration, payment, status)
      payment.update(payment_status: status, reference: payment.payment_uuid)
      complete_renewal_if_ready(registration, status)
    end

    def self.complete_renewal_if_ready(registration, status)
      return unless registration.is_a?(WasteExemptionsEngine::RenewingRegistration)
      return unless status == "success"

      RenewalCompletionService.new(registration).complete_renewal
    end

    def self.registration_by_govpay_id
      payment_by_govpay_id&.account&.registration
    end

    def self.payment_by_govpay_id
      payment = Payment.find_by(govpay_id: @govpay_payment_id)
      payment || handle_payment_not_found
    end

    def self.handle_payment_not_found
      Rails.logger.error "Govpay payment not found for govpay_id #{@govpay_payment_id}"
      Airbrake.notify "Govpay payment not found for govpay_id #{@govpay_payment_id}"
      raise ArgumentError, "invalid govpay_id"
    end
  end
end
