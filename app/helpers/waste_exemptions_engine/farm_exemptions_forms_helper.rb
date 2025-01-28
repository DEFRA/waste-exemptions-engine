# frozen_string_literal: true

module WasteExemptionsEngine
  module FarmExemptionsFormsHelper

    include CanSortExemptions

    def sorted_farm_exemptions
      sorted_exemption_codes(WasteExemptionsEngine::Bucket.farmer_bucket.exemptions)
        .map { |code| Exemption.find_by(code:) }
    end

    def selected_farm_exemptions(transient_registration)
      return [] unless transient_registration.temp_exemptions.present?

      selected_exemptions = transient_registration.temp_exemptions.map { |ex| Exemption.find(ex) }

      sorted_exemptions(selected_exemptions.intersection(WasteExemptionsEngine::Bucket.farmer_bucket.exemptions.to_a))
    end
  end
end
