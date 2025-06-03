# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayPaymentWebhookHandler
    def self.process(webhook_body)
      govpay_id = webhook_body.dig("resource", "payment_id")
      payment = payment_by_govpay_id(govpay_id)

      previous_status = payment&.payment_status

      result = DefraRubyGovpay::WebhookPaymentService.run(
        webhook_body,
        previous_status: previous_status
      )
      govpay_id, status = result.values_at(:id, :status)

      return if payment.blank?

      registration = registration_by_govpay_id(govpay_id)
      return if registration.blank?

      update_payment_status_and_reference(payment, status)

      complete_renewal_if_ready(registration, status)

      Rails.logger.info "Updated status from #{previous_status} to #{status} for payment #{govpay_id}, " \
                        "registration #{registration.reference}"

      result
    rescue StandardError => e
      Rails.logger.error "Error processing webhook for payment #{govpay_id}: #{e}"
      Airbrake.notify "Error processing webhook for payment #{govpay_id}", e
      raise
    end

    def self.update_payment_status_and_reference(payment, status)
      payment.update(payment_status: status, reference: payment.payment_uuid)
    end

    def self.complete_renewal_if_ready(registration, status)
      return unless registration.is_a?(WasteExemptionsEngine::RenewingRegistration)
      return unless status == "success"

      RenewalCompletionService.new(registration).complete_renewal
    end

    def self.registration_by_govpay_id(govpay_id)
      payment_by_govpay_id(govpay_id)&.account&.registration
    end

    def self.payment_by_govpay_id(govpay_id)
      payment = Payment.find_by(govpay_id: govpay_id)
      payment || handle_payment_not_found(govpay_id)
    end

    def self.handle_payment_not_found(govpay_id)
      Rails.logger.error "Govpay payment not found for govpay_id #{govpay_id}"
      Airbrake.notify "Govpay payment not found for govpay_id #{govpay_id}"
      raise ArgumentError, "invalid govpay_id"
    end
  end
end
