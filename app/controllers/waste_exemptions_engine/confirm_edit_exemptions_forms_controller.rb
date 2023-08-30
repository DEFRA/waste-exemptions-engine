# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmEditExemptionsFormsController < FormsController
    def new
      super(ConfirmEditExemptionsForm, "confirm_edit_exemptions_form")
    end

    def create
      super(ConfirmEditExemptionsForm, "confirm_edit_exemptions_form")
    end

    private

    def submit_form(form, params)
      # restore the original exemption_ids if temp_confirm_exemption_edits is not true
      unless params[:temp_confirm_exemption_edits] == "true"
        params[:exemption_ids] = @transient_registration.exemptions.pluck(:id)
      end

      super
    end

    def transient_registration_attributes
      # Cope with a nil value:
      params[:exemption_ids] ||= []
      params.fetch(:confirm_edit_exemptions_form, {}).permit(:temp_confirm_exemption_edits, exemption_ids: [])
    end
  end
end
