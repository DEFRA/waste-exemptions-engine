# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewingRegistration < TransientRegistration
    include CanUseRenewingRegistrationWorkflow
    include CanCopyDataFromRegistration
  end
end
