# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditExemptionsFormsController < FormsController
    def new
      super(ConfirmEditExemptionsForm, "confirm_edit_exemptions_form")
    end
  end
end
