# frozen_string_literal: true

module WasteExemptionsEngine
  class BackOfficeEditCancelledFormsController < FormsController
    helper EditHelper

    include EditPermissionChecks
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(BackOfficeEditCancelledForm, "back_office_edit_cancelled_form")

      EditCancellationService.run(edit_registration: @transient_registration)
    end
  end
end
