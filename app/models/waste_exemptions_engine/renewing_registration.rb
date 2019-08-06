# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewingRegistration < TransientRegistration
    include CanUseRenewingRegistrationWorkflow
    include CanCopyDataFromRegistration

    def referring_registration
      @_referring_registration ||= Registration.find_by(renew_token: token)
    end

    def referring_registration_id
      referring_registration.id
    end

    def registration_attributes
      registration_attributes = super
      registration_attributes["referring_registration_id"] = referring_registration_id

      registration_attributes
    end
  end
end
