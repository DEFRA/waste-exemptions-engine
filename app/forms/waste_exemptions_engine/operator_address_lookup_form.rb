# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupForm < AddressLookupForm
    include CanNavigateFlexibly

    attr_accessor :business_type
    attr_accessor :operator_postcode

    def initialize(enrollment)
      super
      # We only use this for the correct microcopy
      self.business_type = @enrollment.business_type
      self.operator_postcode = @enrollment.interim.operator_postcode

      look_up_addresses
      preselect_existing_address
    end

    private

    def existing_postcode
      operator_postcode
    end

    def existing_address
      @enrollment.operator_address
    end

    def address_type
      Address.address_types[:operator]
    end
  end
end
