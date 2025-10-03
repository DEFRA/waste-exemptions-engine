# frozen_string_literal: true

module WasteExemptionsEngine
  class FindGovpayPaymentService < BaseService
    attr_accessor :govpay_payment_id

    def run(govpay_payment_id)
      @govpay_payment_id = govpay_payment_id

      payment = Payment.find_by(
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_status: Payment::PAYMENT_STATUS_SUCCESS,
        govpay_id: govpay_payment_id
      )

      payment || handle_payment_not_found
    end

    private

    def handle_payment_not_found
      payment = Payment.find_by(govpay_id: govpay_payment_id, payment_type: Payment::PAYMENT_TYPE_GOVPAY)

      message = if !payment.present?
                  "Govpay payment not found for govpay_id #{govpay_payment_id}"
                elsif !Payment.find_by(govpay_id: govpay_payment_id, payment_status: Payment::PAYMENT_STATUS_SUCCESS)
                  "Payment status is not success (#{payment.payment_status}) " \
                    "for payment with govpay_id #{govpay_payment_id}"
                end

      Rails.logger.error message
      Airbrake.notify message
      raise ArgumentError, message
    end
  end
end
