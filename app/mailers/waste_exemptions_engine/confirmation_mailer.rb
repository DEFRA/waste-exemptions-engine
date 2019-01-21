# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmationMailer < ActionMailer::Base
    helper "waste_exemptions_engine/application"
    helper "waste_exemptions_engine/mailer"

    def send_confirmation_email(registration, recipient_email_address)
      @registration = registration

      certificate = generate_pdf_certificate
      attachments["#{registration.reference}.pdf"] = certificate if certificate

      mail(
        to: recipient_email_address,
        from: "#{Rails.configuration.service_name} <#{Rails.configuration.email_service_email}>",
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
      @presenter = CertificatePresenter.new(@registration, view_context)
      pdf_generator = GeneratePdfService.new(
        render_to_string(
          pdf: "certificate",
          template: "waste_exemptions_engine/pdfs/certificate"
        )
      )
      pdf_generator.pdf
    rescue StandardError => error
      Airbrake.notify(error, reference: @registration.reference) if defined?(Airbrake)
      Rails.logger.error "Generate pdf error: #{error}"
      nil
    end

  end
end
