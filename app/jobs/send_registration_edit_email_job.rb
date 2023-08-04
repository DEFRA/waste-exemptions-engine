# frozen_string_literal: true

class SendRegistrationEditEmailJob < ApplicationJob
  def perform(reference:, email:)
    ActiveRecord::Base.transaction do
      registration = WasteExemptionsEngine::RegistrationEmailMatchService.run(reference: reference, email: email)
      return if registration.blank?

      if registration.contact_email.present?
        WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
          registration: registration,
          recipient: registration.contact_email
        )
      end

      if registration.applicant_email.present? && registration.applicant_email != registration.contact_email
        WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
          registration: registration,
          recipient: registration.applicant_email
        )
      end
    end
  end
end
