# frozen_string_literal: true

require "rest-client"

module WasteExemptionsEngine
  class GovpayPaymentDetailsService

    def initialize(govpay_id: nil, is_moto: false, payment_uuid: nil,
                   entity: ::WasteExemptionsEngine::TransientRegistration)
      @payment_uuid = payment_uuid
      @is_moto = is_moto
      @entity = entity
      @govpay_id = govpay_id || payment.govpay_id
    end

    # Payment status in Govpay terms
    def govpay_payment_status
      status = response&.dig("state", "status") || "error"

      # Special case: If failed, check whether this was because of a cancellation
      status = "cancelled" if status == "failed" && response.dig("state", "code") == "P0030"

      status
    rescue StandardError => e
      Rails.logger.error "#{e.class} error retrieving status for payment, " \
                         "uuid #{@payment_uuid}, govpay id #{govpay_id}: #{e}"
      Airbrake.notify(e, message: e.message,
                         payment_uuid:,
                         govpay_id:,
                         entity:)

      raise e
    end

    # Payment status in application terms
    def self.payment_status(status)
      {
        "created" => :pending,
        "started" => :pending,
        "submitted" => :pending,
        "cancelled" => :cancel,
        "failed" => :failure,
        nil => :error
      }.freeze[status] || status.to_sym
    end

    private

    attr_reader :payment_uuid, :entity, :govpay_id

    def defra_ruby_govpay_api
      @defra_ruby_govpay_api ||= DefraRubyGovpay::API.new(
        host_is_back_office: WasteExemptionsEngine.configuration.host_is_back_office?
      )
    end

    def response
      @response ||=
        JSON.parse(
          defra_ruby_govpay_api.send_request(method: :get,
                                             path: "/payments/#{govpay_id}",
                                             is_moto: @is_moto,
                                             params: nil)&.body
        )
    end

    def payment
      Payment.find_by!(payment_uuid: payment_uuid)
    rescue StandardError => e
      Airbrake.notify(e, message: "Order not found for payment uuid", payment_uuid:)
      raise ArgumentError, "Order not found for payment uuid \"#{payment_uuid}\": #{e}"
    end
  end
end
