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
      # ensure the order is persisted before attempting to create a payment
      raise "Order must be persisted before payment can be taken" unless order.persisted?

      @payment = find_or_create_payment
      return {
        payment: @payment,
        url: @transient_registration.temp_govpay_next_url
      } if govpay_payment_in_progress?

      response = send_govpay_payment_request(@payment)
      response_json = JSON.parse(response.body)

      govpay_payment_id = response_json["payment_id"]
      if govpay_payment_id.present?
        govpay_next_url = govpay_redirect_url(response)

        @transient_registration.update(temp_govpay_next_url: govpay_next_url)
        @payment.update(govpay_id: govpay_payment_id)
        {
          payment: @payment,
          url: govpay_next_url
        }
      else
        :error
      end
    rescue StandardError => _e
      # The error will have been logged by CanSendGovPayRequest, just return an error response here
      :error
    end

    def payment_callback_url(payment)
      host = Rails.configuration.host
      path = WasteExemptionsEngine::Engine.routes.url_helpers.payment_callback_govpay_forms_path(
        token: @transient_registration.token, uuid: payment.payment_uuid
      )
      [host, path].join
    end

    def govpay_redirect_url(response)
      JSON.parse(response.body).dig("_links", "next_url", "href")
    end

    private

    attr_reader :payment

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
        moto: host_is_back_office
      }
    end

    def registration_account
      Registration.find_by(reference: @transient_registration.reference).account
    end

    def find_or_create_payment
      # Look for a recent payment for this order that's still in 'created' status
      # and was created in the last 30 minutes (adjust time as needed)
      existing_payment = WasteExemptionsEngine::Payment.where(
        order: order,
        payment_status: Payment::PAYMENT_STATUS_CREATED,
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_amount: order.total_charge_amount,
        account: registration_account
      ).where("created_at > ?", 30.minutes.ago).order(created_at: :desc).first

      # Return existing payment if found, otherwise create a new one
      if existing_payment.present?
        Rails.logger.info "Reusing existing payment #{existing_payment.id} for order #{order.id}"
        existing_payment
      else
        create_payment
      end
    end

    def create_payment
      WasteExemptionsEngine::Payment.create!(
        account: registration_account,
        order: order,
        payment_type: Payment::PAYMENT_TYPE_GOVPAY,
        payment_status: Payment::PAYMENT_STATUS_CREATED,
        payment_uuid: SecureRandom.uuid,
        payment_amount: order.total_charge_amount,
        date_time: Time.zone.now
      )
    end

    def govpay_payment_in_progress?
      return false if payment.govpay_id.blank? || @transient_registration.temp_govpay_next_url.blank?

      # Payment started but cancelled => not in progress
      govpay_payment_status != Payment::PAYMENT_STATUS_CANCELLED
    end

    def govpay_payment_status
      GovpayPaymentDetailsService.new(payment_uuid: payment.payment_uuid,
                                      is_moto: WasteExemptionsEngine.configuration.host_is_back_office?)
        .govpay_payment_status
    end
  end
end
