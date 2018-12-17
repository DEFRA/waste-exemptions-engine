# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorNameFormsController < FormsController
    def new
      super(OperatorNameForm, "operator_name_form")
    end

    def create
      super(OperatorNameForm, "operator_name_form")
    end
  end
end
