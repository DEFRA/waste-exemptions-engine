# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditExemptionsFormsController < FormsController
    def new
      super(ConfirmEditExemptionsForm, "confirm_edit_exemptions_form")
    end

    def create
      return false unless set_up_form(ConfirmEditExemptionsForm, "confirm_edit_exemptions_form", params[:token])

      submit_form(
        @confirm_edit_exemptions_form,
        transient_registration_attributes,
        redirect_to_next: false
      )
    end

    private

    def transient_registration_attributes
      params.fetch(:confirm_edit_exemptions_form, {}).permit(:workflow_state)
    end
  end
end
