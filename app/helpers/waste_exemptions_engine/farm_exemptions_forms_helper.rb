# frozen_string_literal: true

module WasteExemptionsEngine
  module FarmExemptionsFormsHelper
    def sorted_farm_exemptions
      WasteExemptionsEngine::Bucket.farmer_bucket.exemptions.includes([:band]).order(:waste_activity_id, :code)
    end

    def selected_farm_exemptions(transient_registration)
      selected_exemptions = transient_registration.temp_exemptions&.map { |ex| Exemption.find(ex) }
      return [] if selected_exemptions.blank?

      WasteExemptionsEngine::Bucket
        .farmer_bucket
        .exemptions
        .to_a
        .intersection(selected_exemptions)
    end
  end
end
