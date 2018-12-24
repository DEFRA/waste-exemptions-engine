# frozen_string_literal: true

module WasteExemptionsEngine
  module OperatorAddressForm

    attr_accessor :business_type

    def initialize(enrollment)
      super
      # We only use this for the correct microcopy
      self.business_type = @enrollment.business_type
    end

    private

    def existing_address
      @enrollment.operator_address
    end

    def address_type
      Address.address_types[:operator]
    end
  end
end
