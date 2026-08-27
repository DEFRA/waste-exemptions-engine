# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationEmailMatchService < BaseService
    def run(reference:, email:)
      WasteExemptionsEngine::Registration.find_by(
        "reference ilike ? and contact_email ilike ?",
        reference, email
      ) || false
    end
  end
end
