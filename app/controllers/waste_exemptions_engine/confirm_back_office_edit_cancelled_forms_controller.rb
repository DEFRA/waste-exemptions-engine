# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmBackOfficeEditCancelledFormsController < FormsController
    def new
      super(ConfirmBackOfficeEditCancelledForm, "confirm_back_office_edit_cancelled_form")
    end

    def create
      super(ConfirmBackOfficeEditCancelledForm, "confirm_back_office_edit_cancelled_form")
    end
  end
end
