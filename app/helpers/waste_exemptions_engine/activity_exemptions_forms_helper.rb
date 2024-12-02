# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(waste_activity_ids = [])
      WasteExemptionsEngine::Exemption.where(waste_activity_id: waste_activity_ids).order(:waste_activity_id, :id)
    end
  end
end
