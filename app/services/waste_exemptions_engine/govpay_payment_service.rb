# frozen_string_literal: true

require "rest-client"

module WasteExemptionsEngine
  class GovpayPaymentService
    attr_reader :order

    def initialize(transient_registration, order, _user = nil)
      @transient_registration = transient_registration
      @order = order
    end

    def prepare_for_payment
      # ensure the is persisted before attempting to create a payment
      raise "Order must be persisted before payment can be taken" unless order.persisted?

      response = DefraRubyGovpay::API.new(host_is_back_office:).send_request(
        method: :post,
        path: "/payments",
        is_moto: host_is_back_office,
        params: payment_params
      )

      response_json = JSON.parse(response.body)

      govpay_payment_id = response_json["payment_id"]
      if govpay_payment_id.present?
        order.payment = WasteExemptionsEngine::Payment.new(payment_type: :govpay_payment) unless order.payment.present?

        order.payment.govpay_id = govpay_payment_id
        order.payment.save!
        {
          payment: nil, # @payment,
          url: govpay_redirect_url(response)
        }
      else
        :error
      end
    rescue StandardError => e
      # The error will have been logged by CanSendGovPayRequest, just return an error response here
      puts e.message
      byebug
      :error
    end

    def payment_callback_url
      host = Rails.configuration.front_office_url
      path = WasteExemptionsEngine::Engine.routes.url_helpers.payment_callback_govpay_forms_path(
        token: @transient_registration.token, uuid: @order.order_uuid
      )
      [host, path].join
    end

    def govpay_redirect_url(response)
      JSON.parse(response.body).dig("_links", "next_url", "href")
    end

    private

    def host_is_back_office
      @host_is_back_office ||= WasteExemptionsEngine.configuration.host_is_back_office?
    end

    def payment_params
      {
        amount: order.total_charge_amount,
        return_url: payment_callback_url,
        reference: order.order_uuid,
        description: "Your Waste Exemptions Registration #{@transient_registration.reference}",
        moto: WasteExemptionsEngine.configuration.host_is_back_office?
      }
    end
  end
end
