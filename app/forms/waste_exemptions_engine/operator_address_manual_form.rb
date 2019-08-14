# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < AddressManualForm
    include OperatorAddressForm
    include CanSetBusinessType
  end
end
