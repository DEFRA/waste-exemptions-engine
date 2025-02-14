# frozen_string_literal: true

module WasteExemptionsEngine
  module ConfirmActivityExemptionsFormsHelper
    def selected_exemptions(exemption_ids = [], exclude_ids = [])
      WasteExemptionsEngine::Exemption.where(id: exemption_ids)
                                      .where.not(id: exclude_ids)
                                      .order(:band_id, :id)
    end

    def show_farm_exemptions?(transient_registration)
      transient_registration.farm_affiliated? && transient_registration.temp_add_additional_non_farm_exemptions
    end

    def farm_exemptions(transient_registration)
      selected_farm_exemption_ids = transient_registration.temp_exemptions.select do |id|
        WasteExemptionsEngine::Bucket.farmer_bucket.exemption_ids.include?(id)
      end

      WasteExemptionsEngine::Exemption.where(id: selected_farm_exemption_ids).order(:band_id, :id)
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
