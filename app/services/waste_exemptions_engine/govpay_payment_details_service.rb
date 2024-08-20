# frozen_string_literal: true

require "rest-client"

module WasteExemptionsEngine
  class GovpayPaymentDetailsService

    def initialize(govpay_id: nil, is_moto: false, order_uuid: nil,
                   entity: ::WasteExemptionsEngine::TransientRegistration)
      @order_uuid = order_uuid
      @is_moto = is_moto
      @entity = entity
      @govpay_id = govpay_id || order.payment.govpay_id
    end

    # Payment status in Govpay terms
    def govpay_payment_status
      status = response&.dig("state", "status") || "error"

      # Special case: If failed, check whether this was because of a cancellation
      status = "cancelled" if status == "failed" && response.dig("state", "code") == "P0030"

      status
    rescue StandardError => e
      Rails.logger.error "#{e.class} error retrieving status for payment, " \
                         "uuid #{@order_uuid}, govpay id #{govpay_id}: #{e}"
      Airbrake.notify(e, message: e.message,
                         order_uuid:,
                         govpay_id:,
                         entity:)

      raise e
    end

    def payment
      @payment ||= DefraRubyGovpay::Payment.new(response)
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

    attr_reader :order_uuid, :entity, :govpay_id

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

    def order
      Order.find_by!(order_uuid: order_uuid)
    rescue StandardError => e
      Airbrake.notify(e, message: "Order not found for order uuid", order_uuid:)
      raise ArgumentError, "Order not found for order uuid \"#{order_uuid}\": #{e}"
    end
  end
end
