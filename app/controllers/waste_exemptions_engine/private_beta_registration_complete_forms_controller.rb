# frozen_string_literal: true

module WasteExemptionsEngine
  class PrivateBetaRegistrationCompleteFormsController < FormsController
    helper PluralsHelper

    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(PrivateBetaRegistrationCompleteForm, "private_beta_registration_complete_form")

      @registration = RegistrationCompletionService.run(transient_registration: @transient_registration)
    end
  end
end
