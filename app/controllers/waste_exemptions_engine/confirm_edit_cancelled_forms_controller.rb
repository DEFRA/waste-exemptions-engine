# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditCancelledFormsController < FormsController
    def new
      super(ConfirmEditCancelledForm, "confirm_edit_cancelled_form")
    end

    def create
      super(ConfirmEditCancelledForm, "confirm_edit_cancelled_form")
    end
  end
end
