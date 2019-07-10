# frozen_string_literal: true

module WasteExemptionsEngine
  class NewRegistration < TransientRegistration
    include CanUseNewRegistrationWorkflow
  end
end
