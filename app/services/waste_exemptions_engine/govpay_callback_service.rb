# frozen_string_literal: true

require "rest-client"

module WasteExemptionsEngine
  class GovpayCallbackService

    def initialize(order_uuid)
      @order_uuid = order_uuid
      @payment_status = govpay_payment_details_service.govpay_payment_status
      @order = order_by_order_uuid
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
      GovpayPaymentDetailsService.new(order_uuid: @order_uuid,
                                      is_moto: WasteExemptionsEngine.configuration.host_is_back_office?)
    end

    def order_by_order_uuid
      Order.find_by(order_uuid: @order_uuid)
    end

    def valid_unsuccessful_payment?(validation_method)
      return false unless govpay_response_validator(@payment_status).public_send(validation_method)

      @order.update_after_online_payment(@payment_status)
      true
    end

    def update_payment_data
      @order.payment.update(payment_status: "success")
    end

    def govpay_response_validator(govpay_status)
      GovpayValidatorService.new(@order, @order_uuid, govpay_status)
    end
  end
end
