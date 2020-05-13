# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCompleteFormsController < FormsController
    helper EditHelper

    include EditPermissionChecks
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(EditCompleteForm, "edit_complete_form")

      EditCompletionService.run(edit_registration: @transient_registration)
    end
  end
end
