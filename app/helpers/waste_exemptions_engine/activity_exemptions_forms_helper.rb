# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(transient_registration)
      # First get all exemptions for selected waste activities
      exemptions = WasteExemptionsEngine::Exemption.for_waste_activities(transient_registration.temp_waste_activities)

      # If user doesn't want farming exemptions and there is a farmer bucket,
      # exclude exemptions that are in the farmer bucket
      if transient_registration.temp_confirm_exemptions == false && WasteExemptionsEngine::Bucket.farmer_bucket.present?
        farmer_bucket = WasteExemptionsEngine::Bucket.farmer_bucket
        exemptions = exemptions.where.not(id: farmer_bucket.exemption_ids)
      end

      exemptions
    end
  end
end
