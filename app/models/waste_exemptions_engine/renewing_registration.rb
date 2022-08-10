# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewingRegistration < TransientRegistration
    include CanUseRenewingRegistrationWorkflow
    include CanCopyDataFromRegistration

    def referring_registration
      @_referring_registration ||= Registration.find_by(reference: reference)
    end

    def referring_registration_id
      referring_registration.id
    end

    def registration_attributes
      registration_attributes = super
      registration_attributes["referring_registration_id"] = referring_registration_id

      registration_attributes
    end

    def registration_exemptions_to_copy
      registration.active_exemptions + registration.expired_exemptions
    end

    def renewal?
      true
    end

    # renwals cannot change business type
    # this checks for an attempted change, and undoes it
    def changing_business_type?
      return false if referring_registration.business_type == business_type

      self.business_type = referring_registration.business_type
    end
  end
end
