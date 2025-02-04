# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(transient_registration)
      exemptions = WasteExemptionsEngine::Exemption.for_waste_activities(transient_registration.temp_waste_activities)

      # If user wants to add non-farming exemptions,
      # exclude exemptions that are in the farmer bucket
      if !transient_registration.temp_confirm_exemptions && WasteExemptionsEngine::Bucket.farmer_bucket.present?
        farmer_bucket = WasteExemptionsEngine::Bucket.farmer_bucket
        exemptions = exemptions.where.not(id: farmer_bucket.exemption_ids)
      end

      exemptions
    end
  end
end
