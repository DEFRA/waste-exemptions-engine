# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompleteNoChangeFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      super(DeregistrationCompleteNoChangeForm, "deregistration_complete_no_change_form")
    end
  end
end
