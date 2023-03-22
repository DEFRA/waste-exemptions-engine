# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmNoExemptionChangesFormsController < FormsController
    def new
      super(ConfirmNoExemptionChangesForm, "confirm_no_exemption_changes_form")
    end

    def create
      return false unless set_up_form(ConfirmNoExemptionChangesForm, "confirm_no_exemption_changes_form",
                                      params[:token])

      submit_form(
        @confirm_no_exemption_changes_form,
        transient_registration_attributes,
        redirect_to_next: false
      )
    end

    private

    def transient_registration_attributes
      params.fetch(:confirm_no_exemption_changes_form, {}).permit(:workflow_state)
    end
  end
end
