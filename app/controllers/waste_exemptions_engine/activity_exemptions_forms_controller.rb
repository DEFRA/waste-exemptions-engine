# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsFormsController < FormsController
    def new
      super(ActivityExemptionsForm, "activity_exemptions_form")
    end

    def create
      super(ActivityExemptionsForm, "activity_exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:activity_exemptions_form, {}).permit(temp_exemptions: [])
    end
  end
end
