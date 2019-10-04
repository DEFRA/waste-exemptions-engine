# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupForm < AddressLookupFormBase
    delegate :temp_operator_postcode, :operator_address, :business_type, to: :transient_registration

    alias existing_address operator_address
    alias postcode temp_operator_postcode

    validates :operator_address, "waste_exemptions_engine/address": true

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      operator_address = create_address(params[:operator_address][:uprn], :operator)

      super(operator_address: operator_address)
    end
  end
end
