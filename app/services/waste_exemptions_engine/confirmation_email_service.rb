# frozen_string_literal: true

require "notifications/client"

module WasteExemptionsEngine
  class ConfirmationEmailService < BaseService
    def run(registration:, recipient:)
      @registration = registration
      @recipient = recipient
      @pdf = generate_pdf_certificate

      client = Notifications::Client.new(WasteExemptionsEngine.configuration.notify_api_key)

      if @pdf.present?
        client.send_email(options_with_certificate)
      else
        client.send_email(options_without_certificate)
      end
    end

    private

    def options_with_certificate
      {
        email_address: @recipient,
        template_id: "98d5dcee-ea29-415f-952e-b8e287555e10",
        personalisation: {
          reference: @registration.reference,
          link_to_file: Notifications.prepare_upload(prepare_pdf_certificate)
        }
      }
    end

    def options_without_certificate
      {
        email_address: @recipient,
        template_id: "8fcf5d04-944f-4cd1-b261-962fedd3859f",
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
