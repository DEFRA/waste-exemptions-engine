# frozen_string_literal: true

module WasteExemptionsEngine
  class NewChargedRegistration < TransientRegistration
    include CanUseNewChargedRegistrationWorkflow

    has_one :order, as: :order_owner

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

    def prepare_for_payment(mode, _user = nil)
      # @todo: Update payment details if necessary
    end
  end
end
