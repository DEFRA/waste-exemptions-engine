# frozen_string_literal: true

module WasteExemptionsEngine
  class NewChargedRegistration < TransientRegistration
    include CanUseNewChargedRegistrationWorkflow

    # temp attribute to temporarily keep selected payment type.
    # It needs to be removed once the payment type is stored
    attr_accessor :payment_type

    def initialize(params)
      super

      # Set the initial assistance_mode value to the application's default_assistance_mode
      self.assistance_mode = WasteExemptionsEngine.configuration.default_assistance_mode
    end

    def charged?
      true
    end
  end
end
