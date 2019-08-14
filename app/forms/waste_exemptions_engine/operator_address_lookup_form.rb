# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupForm < AddressLookupForm
    include OperatorAddressForm

    set_callback :initialize, :after, :set_business_type
  end
end
