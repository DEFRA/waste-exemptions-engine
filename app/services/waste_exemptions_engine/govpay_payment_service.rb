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

      @payment = create_payment
      response = send_govpay_payment_request(@payment)
      response_json = JSON.parse(response.body)

      govpay_payment_id = response_json["payment_id"]
      if govpay_payment_id.present?
        @payment.update(govpay_id: govpay_payment_id)
        {
          payment: @payment, # @payment,
          url: govpay_redirect_url(response)
        }
      else
        :error
      end
    rescue StandardError => _e
      # The error will have been logged by CanSendGovPayRequest, just return an error response here
      :error
    end

    def payment_callback_url(payment)
      host = Rails.configuration.front_office_url
      path = WasteExemptionsEngine::Engine.routes.url_helpers.payment_callback_govpay_forms_path(
        token: @transient_registration.token, uuid: payment.payment_uuid
      )
      [host, path].join
    end

    def govpay_redirect_url(response)
      JSON.parse(response.body).dig("_links", "next_url", "href")
    end

    private

    def send_govpay_payment_request(payment)
      DefraRubyGovpay::API.new(host_is_back_office:).send_request(
        method: :post,
        path: "/payments",
        is_moto: host_is_back_office,
        params: payment_params(payment)
      )
    end

    def host_is_back_office
      @host_is_back_office ||= WasteExemptionsEngine.configuration.host_is_back_office?
    end

    def payment_params(payment)
      {
        amount: order.total_charge_amount,
        return_url: payment_callback_url(payment),
        reference: payment.payment_uuid,
        description: "Your Waste Exemptions Registration #{@transient_registration.reference}",
        moto: WasteExemptionsEngine.configuration.host_is_back_office?
      }
    end

    def create_payment
      WasteExemptionsEngine::Payment.create!(
        order: order,
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_status: Payment::PAYMENT_STATUS_CREATED,
        payment_uuid: SecureRandom.uuid
      )
    end
  end
end
