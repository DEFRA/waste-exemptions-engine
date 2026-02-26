# frozen_string_literal: true

module WasteExemptionsEngine
  module ConfirmActivityExemptionsFormsHelper
    def selected_exemptions(exemption_ids = [])
      WasteExemptionsEngine::Exemption.where(id: exemption_ids)
                                      .order(:band_id, :id)
    end

    def exemptions_by_band(exemptions)
      exemptions.group_by(&:band_id).sort.map do |_band_id, band_exemptions|
        {
          name: band_exemptions.first.band&.name,
          exemptions: band_exemptions
        }
      end
    end
  end
end
