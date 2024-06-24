# frozen_string_literal: true

module WasteExemptionsEngine
  class NewChargedRegistration < TransientRegistration
    include CanUseNewChargedRegistrationWorkflow

    def initialize(params)
      super

      # Set the initial assistance_mode value to the application's default_assistance_mode
      self.assistance_mode = WasteExemptionsEngine.configuration.default_assistance_mode
    end
  end
end
