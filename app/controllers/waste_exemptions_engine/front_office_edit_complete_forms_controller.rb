# frozen_string_literal: true

module WasteExemptionsEngine
  class FrontOfficeEditCompleteFormsController < FormsController
    helper EditHelper

    include CannotGoBackForm
    include CannotSubmitForm

    def new
      return unless super(FrontOfficeEditCompleteForm, "front_office_edit_complete_form")

      FrontOfficeEditCompletionService.run(edit_registration: @transient_registration,
                                           preload: { addresses: :registration_exemptions })
    end
  end
end
