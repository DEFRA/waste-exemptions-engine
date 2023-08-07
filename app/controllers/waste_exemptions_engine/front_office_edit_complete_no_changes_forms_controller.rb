# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompleteNoChangesFormsController < FormsController
    helper EditHelper

    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(FrontOfficeEditCompleteNoChangesForm, "front_office_edit_complete_no_changes_form")

      FrontOfficeEditCompletionService.run(edit_registration: @transient_registration)
    end
  end
end
