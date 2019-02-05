# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmerFormsController < FormsController
    def new
      super(IsAFarmerForm, "is_a_farmer_form")
    end

    def create
      super(IsAFarmerForm, "is_a_farmer_form")
    end
  end
end
