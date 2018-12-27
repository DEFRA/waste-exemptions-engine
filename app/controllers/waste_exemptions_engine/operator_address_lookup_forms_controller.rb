# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupFormsController < AddressLookupFormsController
    def new
      super(OperatorAddressLookupForm, "operator_address_lookup_form")
    end

    def create
      super(OperatorAddressLookupForm, "operator_address_lookup_form")
    end
  end
end
