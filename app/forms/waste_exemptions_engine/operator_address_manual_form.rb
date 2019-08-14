# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < AddressManualForm
    include OperatorAddressForm

    set_callback :initialize, :after, :set_business_type
  end
end
