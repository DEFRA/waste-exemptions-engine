# frozen_string_literal: true

module WasteExemptionsEngine
  class RegisterInScotlandFormsController < FormsController
    include CannotSubmitForm

    def new
      super(RegisterInScotlandForm, "register_in_scotland_form")
    end
  end
end
