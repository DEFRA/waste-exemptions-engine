# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressLookupForm < AddressLookupFormBase
    delegate :temp_operator_postcode, :operator_address, :business_type, to: :transient_registration

    alias existing_address operator_address
    alias postcode temp_operator_postcode

    validates :operator_address, "waste_exemptions_engine/address": true

    def submit(params)
      operator_address_params = params.fetch(:operator_address, {})
      operator_address_attributes = get_address_data(operator_address_params[:uprn], :operator)

      super(operator_address_attributes: operator_address_attributes)
    end
  end
end
