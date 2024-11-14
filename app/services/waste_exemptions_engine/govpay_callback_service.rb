# frozen_string_literal: true

require "rest-client"

module WasteExemptionsEngine
  class GovpayCallbackService

    def initialize(payment_uuid)
      @payment_uuid = payment_uuid
      @payment_status = govpay_payment_details_service.govpay_payment_status
      @payment = payment_by_payment_uuid
      @transient_registration = @order&.order_owner
    end

    def valid_success?
      return false unless govpay_response_validator("success").valid_success?

      update_payment_data

      true
    end

    def valid_failure?
      valid_unsuccessful_payment?(:valid_failure?)
    end

    def valid_pending?
      valid_unsuccessful_payment?(:valid_pending?)
    end

    def valid_cancel?
      valid_unsuccessful_payment?(:valid_cancel?)
    end

    def valid_error?
      valid_unsuccessful_payment?(:valid_error?)
    end

    private

    def govpay_payment_details_service
      GovpayPaymentDetailsService.new(payment_uuid: @payment_uuid,
                                      is_moto: WasteExemptionsEngine.configuration.host_is_back_office?)
    end

    def payment_by_payment_uuid
      Payment.find_by(payment_uuid: @payment_uuid)
    end

    def valid_unsuccessful_payment?(validation_method)
      return false unless govpay_response_validator(@payment_status).public_send(validation_method)

      @payment.update(payment_status: @payment_status)
      true
    end

    def update_payment_data
      @payment.update(payment_status: "success", reference: @payment.payment_uuid)
    end

    def govpay_response_validator(govpay_status)
      GovpayValidatorService.new(@payment&.order, @payment_uuid, govpay_status)
    end
  end
end
