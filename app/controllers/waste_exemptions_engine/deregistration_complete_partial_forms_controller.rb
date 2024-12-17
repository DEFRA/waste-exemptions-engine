# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompletePartialFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(DeregistrationCompletePartialForm, "deregistration_complete_partial_form")

      @transient_registration.destroy
    end
  end
end
