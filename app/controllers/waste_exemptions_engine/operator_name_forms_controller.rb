# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorNameFormsController < FormsController
    def new
      super(OperatorNameForm, "operator_name_form")
    end

    def create
      super(OperatorNameForm, "operator_name_form")
    end

    private

    def transient_registration_attributes
      params.require(:operator_name_form).permit(:operator_name)
    end
  end
end
