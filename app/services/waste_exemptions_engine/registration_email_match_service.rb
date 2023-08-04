# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationEmailMatchService < BaseService
    def run(reference:, email:)
      WasteExemptionsEngine::Registration.where("reference ilike ? and (applicant_email ilike ? OR contact_email ilike ?)", reference, email, email).first || false
    end
  end
end
