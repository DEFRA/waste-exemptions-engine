# frozen_string_literal: true

require "waste_exemptions_engine/detailed_logger"

module WasteExemptionsEngine
  class GovpayWebhookJob < ApplicationJob

    # Prevent ActiveJob from logging the full webhook body
    self.log_arguments = false

    def perform(webhook_body)
      Rails.logger.warn "\n>>> Processing webhook job for: #{webhook_body.inspect}"
      if webhook_body["resource_type"]&.downcase == "payment"
        process_payment_webhook(webhook_body)
      elsif webhook_body["refund_id"].present?
        process_refund_webhook(webhook_body)
      else
        raise ArgumentError, "Unrecognised Govpay webhook type"
      end
    rescue StandardError => e
      handle_error(e, webhook_body)
    end

    private

    def process_payment_webhook(webhook_body)
      Rails.logger.warn "\n>>>> Processing webhook for payment #{webhook_body['resource_id']} : #{webhook_body.dig(
        'resource', 'payment_id'
      )}"
      result = GovpayPaymentWebhookHandler.process(webhook_body)

      Rails.logger.info "Processed payment webhook for govpay_id: #{result[:id]}, status: #{result[:status]}"
    end

    def process_refund_webhook(webhook_body)
      Rails.logger.warn "\n>>>> Processing webhook for refund #{webhook_body['refund_id']}"
      result = GovpayRefundWebhookHandler.run(webhook_body)

      Rails.logger.info "Processed refund webhook for refund_id: #{result[:id]}, status: #{result[:status]}"
    end

    def sanitize_webhook_body(body)
      DefraRubyGovpay::WebhookSanitizerService.call(body)
    end

    def handle_error(error, webhook_body)
      service_type = webhook_body.dig("resource", "moto") ? "back_office" : "front_office"
      Rails.logger.error "Error running GovpayWebhookJob (#{service_type}): #{error}"
      notification_params = {
        refund_id: webhook_body&.dig("resource", "refund_id") || webhook_body&.dig("refund_id"),
        payment_id: webhook_body&.dig("resource", "payment_id") || webhook_body&.dig("payment_id"),
        service_type: service_type
      }

      if FeatureToggle.active?(:detailed_logging)
        notification_params[:webhook_body] = sanitize_webhook_body(webhook_body)
        DetailedLogger.error "Webhook job error #{error}: #{notification_params}"
      end

      Airbrake.notify(error, notification_params)
    end
  end
end
