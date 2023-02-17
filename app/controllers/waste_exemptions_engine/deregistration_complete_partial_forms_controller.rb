# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompletePartialFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      super(DeregistrationCompletePartialForm, "deregistration_complete_partial_form")
    end
  end
end
