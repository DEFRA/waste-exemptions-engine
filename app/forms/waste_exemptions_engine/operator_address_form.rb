# frozen_string_literal: true

module WasteExemptionsEngine
  module OperatorAddressForm

    attr_accessor :business_type

    def initialize(registration)
      super
      # We only use this for the correct microcopy
      self.business_type = @registration.business_type
    end

    private

    def existing_postcode
      @registration.interim.operator_postcode
    end

    def existing_address
      @registration.operator_address
    end

    def address_type
      Address.address_types[:operator]
    end
  end
end
