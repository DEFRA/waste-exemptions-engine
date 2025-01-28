# frozen_string_literal: true

module WasteExemptionsEngine
  class NoFarmExemptionsSelectedFormsController < FormsController
    def new
      super(NoFarmExemptionsSelectedForm, "no_farm_exemptions_selected_form")
    end
  end
end
