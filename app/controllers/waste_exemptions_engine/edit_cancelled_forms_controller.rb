# frozen_string_literal: true

module WasteExemptionsEngine
  class EditCancelledFormsController < FormsController
    helper EditHelper

    include EditPermissionChecks
    include CannotGoBackForm
    include UnsubmittableForm

    def new
      return unless super(EditCancelledForm, "edit_cancelled_form")

      EditCancellationService.run(edit_registration: @transient_registration)
    end
  end
end
