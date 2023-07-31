# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationLookupCompleteFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      super(RegistrationLookupCompleteForm, "registration_lookup_complete_form")
    end
  end
end
