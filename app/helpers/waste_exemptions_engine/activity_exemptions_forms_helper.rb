# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(waste_activity_ids = [])
      exemptions = WasteExemptionsEngine::Exemption.where(waste_activity_id: waste_activity_ids).order(:waste_activity_id, :id)

      # If user wants to add non-farming exemptions,
      # exclude exemptions that are in the farmer bucket
      unless @activity_exemptions_form.transient_registration.temp_confirm_exemptions
        farmer_bucket = WasteExemptionsEngine::Bucket.farmer_bucket
        exemptions = exemptions.where.not(id: farmer_bucket.exemption_ids) if farmer_bucket
      end

      exemptions
    end
  end
end
