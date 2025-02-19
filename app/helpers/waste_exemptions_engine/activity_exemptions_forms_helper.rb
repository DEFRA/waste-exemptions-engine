# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(transient_registration)
      exemptions = WasteExemptionsEngine::Exemption.for_waste_activities(transient_registration.temp_waste_activities)

      # If user doesn't want farming exemptions and there is a farmer bucket,
      # exclude exemptions that are in the farmer bucket
      farmer_bucket = WasteExemptionsEngine::Bucket.farmer_bucket
      if farmer_bucket.present? && exclude_farming_exemptions?(transient_registration)
        exemptions = exemptions.where.not(id: farmer_bucket.exemption_ids)
      end

      exemptions
    end

    private

    def exclude_farming_exemptions?(transient_registration)
      transient_registration.temp_add_additional_non_bucket_exemptions == true &&
        transient_registration.farm_affiliated?
    end
  end
end
