# frozen_string_literal: true

module WasteExemptionsEngine
  class RenewalCompleteFormsController < FormsController
    def new
      return unless super(RenewalCompleteForm, "renewal_complete_form")

      registration_completion_service = RegistrationCompletionService.new(@transient_registration)
      registration_completion_service.complete
    end

    # Overwrite create and go_back as you shouldn't be able to submit or go back
    def create; end

    def go_back; end
  end
end
