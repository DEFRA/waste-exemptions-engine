# frozen_string_literal: true

module WasteExemptionsEngine
  class GovpayWebhookCallbacksController < ::WasteExemptionsEngine::ApplicationController
    protect_from_forgery with: :null_session

    def process_webhook
      pay_signature = request.headers["Pay-Signature"]
      # need to rewind in case already read
      request.body.rewind
      body = request.body.read

      raise ArgumentError, "Govpay payment webhook request missing Pay-Signature header" unless pay_signature.present?

      DefraRubyGovpay::WebhookBodyValidatorService.run(body: body, signature: pay_signature)

      GovpayWebhookJob.perform_later(JSON.parse(body))
    rescue StandardError, Mongoid::Errors::DocumentNotFound => e
      Rails.logger.error "Govpay payment webhook body validation failed: #{e}"
      Airbrake.notify(e, body: body, signature: pay_signature)
    ensure
      # always return 200 to Govpay even if validation fails
      render nothing: true, layout: false, status: 200
    end
  end
end
