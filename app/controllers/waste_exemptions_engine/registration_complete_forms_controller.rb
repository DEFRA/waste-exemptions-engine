# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationCompleteFormsController < FormsController
    def new
      return unless super(RegistrationCompleteForm, "registration_complete_form")

      registration = RegistrationCompletionService.run(transient_registration: @transient_registration)
      @registration_complete_form.reference = registration.reference
    end

    # Overwrite create and go_back as you shouldn't be able to submit or go back
    def create; end

    def go_back; end
  end
end
