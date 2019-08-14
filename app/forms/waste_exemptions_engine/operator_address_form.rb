# frozen_string_literal: true

module WasteExemptionsEngine
  module OperatorAddressForm
    attr_accessor :business_type

    private

    def set_business_type
      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
    end

    def existing_postcode
      @transient_registration.temp_operator_postcode
    end

    def existing_address
      @transient_registration.operator_address
    end

    def address_type
      TransientAddress.address_types[:operator]
    end
  end
end
