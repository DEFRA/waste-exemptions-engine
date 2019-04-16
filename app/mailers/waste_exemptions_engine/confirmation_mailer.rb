# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmationMailer < ActionMailer::Base
    helper "waste_exemptions_engine/application"
    helper "waste_exemptions_engine/mailer"

    def send_confirmation_email(registration, recipient_email_address)
      @registration = registration

      certificate = generate_pdf_certificate
      attachments["#{registration.reference}.pdf"] = certificate if certificate
      attachments["privacy_policy.pdf"] = privacy_policy

      config = WasteExemptionsEngine.configuration

      mail(
        to: recipient_email_address,
        from: "#{config.service_name} <#{config.email_service_email}>",
        subject: I18n.t(".waste_exemptions_engine.confirmation_mailer.send_confirmation_email.subject",
                        reference: @registration.reference)
      )
    end

    private

    # We wrap the generation of the pdf in a rescue block, because though it's
    # not ideal that the user doesn't get their certificate attached if an error
    # occurs, we also don't want to block their renewal from completing because
    # of it
    def generate_pdf_certificate
      ConfirmationPdfGeneratorService.run(registration: @registration)
    rescue StandardError => error
      Airbrake.notify(error, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Generate pdf error: #{error}"
      nil
    end

    def privacy_policy
      root_path = File.join(__dir__, "..", "..", "..")
      privacy_pdf_path = File.absolute_path(File.join(root_path, "lib/privacy_policy.pdf"))

      File.read(privacy_pdf_path)
    end

  end
end
