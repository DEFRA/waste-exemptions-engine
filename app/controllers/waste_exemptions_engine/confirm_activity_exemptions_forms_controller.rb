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

    def submit_form(form, params)
      # redirect to select-waste-activities if the option is not true
      if params[:temp_confirm_exemptions] == "false"
        back_to_waste_activities
        return
      end

      super
    end

    def back_to_waste_activities
      @confirm_activity_exemptions_form.transient_registration.update(workflow_state: "waste_activities_form")
      redirect_to_correct_form
    end

    def transient_registration_attributes
      params.fetch(:confirm_activity_exemptions_form, {}).permit(:temp_confirm_exemptions)
    end
  end
end
