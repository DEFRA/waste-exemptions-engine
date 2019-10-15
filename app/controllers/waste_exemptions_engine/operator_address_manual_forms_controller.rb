# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualFormsController < FormsController
    def new
      super(OperatorAddressManualForm, "operator_address_manual_form")
    end

    def create
      super(OperatorAddressManualForm, "operator_address_manual_form")
    end

    private

    def transient_registration_attributes
      params
        .fetch(:operator_address_manual_form, {})
        .permit(operator_address: %i[locality postcode city premises street_address mode])
    end
  end
end
