# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompleteFullFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      super(DeregistrationCompleteFullForm, "deregistration_complete_full_form")
    end
  end
end
