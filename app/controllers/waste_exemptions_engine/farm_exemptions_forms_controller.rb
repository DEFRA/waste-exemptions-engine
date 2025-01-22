# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsFormsController < FormsController
    def new
      super(FarmExemptionsForm, "farm_exemptions_form")
    end

    def create
      super(FarmExemptionsForm, "farm_exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:farm_exemptions_form, {}).permit(temp_exemptions: [])
    end
  end
end
