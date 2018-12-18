# frozen_string_literal: true

module WasteExemptionsEngine
  class OnAFarmFormsController < FormsController
    def new
      super(OnAFarmForm, "on_a_farm_form")
    end

    def create
      super(OnAFarmForm, "on_a_farm_form")
    end
  end
end
