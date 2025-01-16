# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmFarmExemptionsFormsController < FormsController
    helper FarmExemptionsFormsHelper
    def new
      super(ConfirmFarmExemptionsForm, "confirm_farm_exemptions_form")
    end

    def create
      super(ConfirmFarmExemptionsForm, "confirm_farm_exemptions_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:confirm_farm_exemptions_form, {}).permit(:temp_confirm_exemptions)
    end
  end
end
