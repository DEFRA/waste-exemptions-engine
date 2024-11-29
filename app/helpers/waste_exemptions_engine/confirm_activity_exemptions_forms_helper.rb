# frozen_string_literal: true

module WasteExemptionsEngine
  module ConfirmActivityExemptionsFormsHelper
    def selected_activity_exemptions(waste_activity_ids = [])
      WasteExemptionsEngine::Exemption.where(id: waste_activity_ids).order(:band_id, :id)
    end
  end
end
