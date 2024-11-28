# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmActivityExemptionsFormsController < FormsController
    def new
      super(ConfirmActivityExemptionsForm, "confirm_activity_exemptions_form")
    end

    def create
      super(ConfirmActivityExemptionsForm, "confirm_activity_exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:confirm_activity_exemptions_form, {}).permit(:temp_confirm_exemptions)
    end
  end
end
