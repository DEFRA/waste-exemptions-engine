# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmationMailer < ActionMailer::Base
    helper "waste_exemptions_engine/application"
    helper "waste_exemptions_engine/mailer"

    def send_confirmation_email(registration, recipient_email_address)
      @registration = registration

      mail(
        to: recipient_email_address,
        from: "#{Rails.configuration.service_name} <#{Rails.configuration.email_service_email}>",
        subject: I18n.t(".waste_exemptions_engine.confirmation_mailer.send_confirmation_email.subject",
                        reference: @registration.reference)
      )
    end

  end
end
