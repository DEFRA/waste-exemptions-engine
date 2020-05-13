# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteFormsController < FormsController
    helper PluralsHelper

    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(RegistrationCompleteForm, "registration_complete_form")

      @registration = RegistrationCompletionService.run(transient_registration: @transient_registration)
    end
  end
end
