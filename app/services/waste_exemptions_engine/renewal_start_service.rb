# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalStartService < BaseService
    def run(registration:)
      # Check for edge cases at renewal time where an edit registration was previously
      # created and has not yet been cleaned up.
      transient_registration = TransientRegistration.where(reference: registration.reference).first

      if transient_registration.present?
        Rails.logger.info "Removing existing transient registration of type #{transient_registration.class} " \
                          "before starting renewal of #{registration.reference}"
        transient_registration.destroy
      end

      RenewingRegistration.create!(reference: registration.reference)
    end
  end
end
