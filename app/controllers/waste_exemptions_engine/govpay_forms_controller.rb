# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayFormsController < FormsController

    def new
      super(GovpayForm, "govpay_form")

      payment_info = prepare_for_payment

      if payment_info == :error
        flash[:error] = I18n.t(".waste_exemptions_engine.govpay_forms.new.setup_error")
        go_back
      else
        redirect_to payment_info[:url], allow_other_host: true
      end
    end

    def payment_callback
      @transient_registration ||= TransientRegistration.where(token: params[:token]).first

      govpay_payment_status = GovpayPaymentDetailsService.new(
        order_uuid: params[:uuid],
        is_moto: WasteExemptionsEngine.configuration.host_is_back_office?
      ).govpay_payment_status

      @transient_registration.with_lock do
        case GovpayPaymentDetailsService.payment_status(govpay_payment_status)
        when :success, :pending
          respond_to_acceptable_payment(govpay_payment_status)
        else
          respond_to_unsuccessful_payment(govpay_payment_status)
        end
      end
    rescue StandardError => e
      Rails.logger.warn "Govpay payment callback error for order uuid \"#{params[:uuid]}\": #{e}"
      Airbrake.notify(e, message: "Govpay callback error for order uuid", order_uuid: params[:uuid])
      flash[:error] = I18n.t(".waste_exemptions_engine.govpay_forms.new.internal_error")
      go_back
    end

    private

    def prepare_for_payment
      @transient_registration.prepare_for_payment(:govpay)
      order = @transient_registration.order
      govpay_service = GovpayPaymentService.new(@transient_registration, order)
      govpay_service.prepare_for_payment
    end

    def respond_to_acceptable_payment(action)
      return unless valid_transient_registration?

      if response_is_valid?(action, params)
        log_and_send_govpay_response(true, action)
        @transient_registration.next!
        redirect_to_correct_form
      else
        log_and_send_govpay_response(false, action)
        form_error_message(action, :invalid_response)
        go_back
      end
    end

    def respond_to_unsuccessful_payment(action)
      return unless valid_transient_registration?

      if response_is_valid?(action, params)
        log_and_send_govpay_response(true, action)
        form_error_message(action)
      else
        log_and_send_govpay_response(false, action)
        form_error_message(action, :invalid_response)
      end

      go_back
    end

    def valid_transient_registration?
      setup_checks_pass?
    end

    def response_is_valid?(action, params)
      valid_method = :"valid_#{GovpayPaymentDetailsService.payment_status(action)}?"
      order_uuid = params[:uuid]
      govpay_service = GovpayCallbackService.new(order_uuid)

      govpay_service.public_send(valid_method)
    end

    def log_and_send_govpay_response(is_valid, action)
      return if is_valid && action != "error"

      valid_text = is_valid ? "Valid" : "Invalid"
      title = "#{valid_text} Govpay response: #{action}"
      Rails.logger.debug [title, "Params:", params.to_json].join("\n")
      Airbrake.notify(title, error_message: params)
    end

    def form_error_message(action, type = :message)
      action = GovpayPaymentDetailsService.payment_status(action)
      flash[:error] = I18n.t(".waste_exemptions_engine.govpay_forms.#{action}.#{type}")
    end
  end
end
