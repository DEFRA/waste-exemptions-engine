# frozen_string_literal: true

module WasteExemptionsEngine
  module ConfirmActivityExemptionsFormsHelper
    def selected_exemptions(exemption_ids = [])
      WasteExemptionsEngine::Exemption.where(id: exemption_ids)
                                      .order(:id)
    end
  end
end
