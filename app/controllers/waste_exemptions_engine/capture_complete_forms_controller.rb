# frozen_string_literal: true

module WasteExemptionsEngine
  class CaptureCompleteFormsController < FormsController
    include CannotGoBackForm
    include CannotSubmitForm

    def new
      super(CaptureEmailForm, "capture_complete_form")
    end
  end
end
