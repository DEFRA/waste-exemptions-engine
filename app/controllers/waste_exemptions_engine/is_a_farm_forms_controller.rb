# frozen_string_literal: true

module WasteExemptionsEngine
  class IsAFarmFormsController < FormsController
    def new
      super(IsAFarmForm, "is_a_farm_form")
    end

    def create
      super(IsAFarmForm, "is_a_farm_form")
    end
  end
end
