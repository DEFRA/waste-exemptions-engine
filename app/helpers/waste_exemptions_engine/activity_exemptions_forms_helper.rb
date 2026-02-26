# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(transient_registration)
      WasteExemptionsEngine::Exemption.for_waste_activities(transient_registration.temp_waste_activities)
    end
  end
end
