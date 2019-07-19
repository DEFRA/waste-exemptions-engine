# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewingRegistration < TransientRegistration
    include CanUseNewRegistrationWorkflow
  end
end
