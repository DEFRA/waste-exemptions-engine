# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupForm < AddressLookupFormBase
    delegate :temp_operator_postcode, :operator_address, :business_type, to: :transient_registration

    alias existing_address operator_address
    alias postcode temp_operator_postcode

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      operator_address = create_address(params[:temp_address], :operator)

      self.temp_address = operator_address

      super(operator_address: operator_address)
    end
  end
end
