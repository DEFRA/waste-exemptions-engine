# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompleteFullFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(DeregistrationCompleteFullForm, "deregistration_complete_full_form")

      @transient_registration.destroy
    end
  end
end
