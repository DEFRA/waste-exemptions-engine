# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmerFormsController < FormsController
    def new
      super(IsAFarmerForm, "is_a_farmer_form")
    end

    def create
      super(IsAFarmerForm, "is_a_farmer_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:is_a_farmer_form, {}).permit(:is_a_farmer)
    end
  end
end
