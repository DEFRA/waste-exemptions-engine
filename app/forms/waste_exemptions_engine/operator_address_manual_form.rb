# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < ManualAddressForm
    include CanNavigateFlexibly

    private

    def saved_temp_postcode
      @enrollment.interim.operator_postcode
    end

    def existing_address
      @enrollment.operator_address
    end

    def address_type
      Address.address_types[:operator]
    end
  end
end
