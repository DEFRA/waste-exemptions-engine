# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeFormsController < PostcodeFormsController
    def new
      super(OperatorPostcodeForm, "operator_postcode_form")
    end

    def create
      super(OperatorPostcodeForm, "operator_postcode_form")
    end

    private

    def transient_registration_attributes
      params.require(:operator_postcode_form).permit(:temp_operator_postcode)
    end
  end
end
