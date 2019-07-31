# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartService < BaseService
    def run(registration:)
      RenewingRegistration.find_or_create_by(reference: registration.reference)
    end
  end
end
