# frozen_string_literal: true

module WasteExemptionsEngine
  class DeregistrationCompleteNoChangeFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(DeregistrationCompleteNoChangeForm, "deregistration_complete_no_change_form")

      @transient_registration.destroy
    end
  end
end
