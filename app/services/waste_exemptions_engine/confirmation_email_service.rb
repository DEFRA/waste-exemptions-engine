# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class ConfirmationEmailService < BaseService
    include CanHaveCommunicationLog

    def run(registration:, recipient:)
      @registration = registration
      @recipient = recipient
      @pdf = generate_pdf_certificate

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      result = client.send_email(@pdf.present? ? options_with_certificate : options_without_certificate)

      create_log(registration:)

      result
    end

    def template_id
      @pdf.present? ? "9025773f-35a3-4894-b8c6-105d65c19df4" : "8fcf5d04-944f-4cd1-b261-962fedd3859f"
    end

    # For CanHaveCommunicationLog
    def communications_log_params
      {
        message_type: "email",
        template_id: template_id,
        template_label: "Registration completion email",
        sent_to: @recipient
      }
    end

    private

    def options_with_certificate
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: {
          reference: @registration.reference,
          link_to_file: WasteExemptionsEngine::ViewCertificateLinkService.run(registration: @registration),
          unsubscribe_link: WasteExemptionsEngine::UnsubscribeLinkService.run(registration: @registration)
        }
      }
    end

    def options_without_certificate
      {
        email_address: @recipient,
        template_id: template_id,
        personalisation: {
          reference: @registration.reference
        }
      }
    end

    def prepare_pdf_certificate
      StringIO.new(@pdf)
    end

    # We wrap the generation of the pdf in a rescue block, because though it's
    # not ideal that the user doesn't get their certificate attached if an error
    # occurs, we also don't want to block their renewal from completing because
    # of it
    def generate_pdf_certificate
      ConfirmationPdfGeneratorService.run(registration: @registration)
    rescue StandardError => e
      Airbrake.notify(e, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Generate pdf error: #{e}"
      nil
    end
  end
end
