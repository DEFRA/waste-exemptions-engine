# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationEmailMatchService < BaseService
    def run(reference:, email:)
      WasteExemptionsEngine::Registration.where(reference: reference, contact_email: email).or(
        WasteExemptionsEngine::Registration.where(reference: reference, applicant_email: email)
      ).first || false
    end
  end
end
