# frozen_string_literal: true

module WasteExemptionsEngine
  class BackOfficeEditCompleteFormsController < FormsController
    helper EditHelper

    include EditPermissionChecks
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(BackOfficeEditCompleteForm, "back_office_edit_complete_form")

      EditCompletionService.run(edit_registration: @transient_registration,
                                preload: { addresses: :registration_exemptions })
    end
  end
end
