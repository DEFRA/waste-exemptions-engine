# frozen_string_literal: true

class SendRegistrationEditEmailJob < ApplicationJob
  def perform(reference:, email:)
    ActiveRecord::Base.transaction do
      registration = WasteExemptionsEngine::RegistrationEmailMatchService.run(reference: reference, email: email)
      return if registration.blank?

      WasteExemptionsEngine::RegistrationEditLinkEmailService.run(
        registration: registration,
        recipient: email
      )
    end
  end
end
