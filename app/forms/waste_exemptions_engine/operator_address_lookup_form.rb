# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupForm < AddressLookupForm
    include OperatorAddressForm
    include CanSetBusinessType
  end
end
