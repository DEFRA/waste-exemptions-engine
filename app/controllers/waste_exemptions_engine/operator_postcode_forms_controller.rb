# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeFormsController < PostcodeFormsController
    def new
      super(OperatorPostcodeForm, "operator_postcode_form")
    end

    def create
      super(OperatorPostcodeForm, "operator_postcode_form")
    end
  end
end
