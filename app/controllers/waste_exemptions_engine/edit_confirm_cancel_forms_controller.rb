# frozen_string_literal: true

module WasteExemptionsEngine
  class EditConfirmCancelFormsController < FormsController
    def new
      super(EditConfirmCancelForm, "edit_confirm_cancel_form")
    end

    def create
      super(EditConfirmCancelForm, "edit_confirm_cancel_form")
    end
  end
end
