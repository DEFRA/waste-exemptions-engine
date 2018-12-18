# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressFormsController < AddressFormsController
    def new
      super(OperatorAddressForm, "operator_address_form")
    end

    def create
      super(OperatorAddressForm, "operator_address_form")
    end
  end
end
