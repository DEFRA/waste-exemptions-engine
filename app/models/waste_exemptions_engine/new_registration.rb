# frozen_string_literal: true

module WasteExemptionsEngine
  class NewRegistration < TransientRegistration
    include CanUseNewRegistrationWorkflow

    def initialize(params)
      super(params)

      # Set the initial assistance_mode value to the application's default_assistance_mode
      self.assistance_mode = WasteExemptionsEngine.configuration.default_assistance_mode
    end
  end
end
