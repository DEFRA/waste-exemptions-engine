# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    def submit(params)
      # Get the current exemptions and new farm exemptions
      current_exemptions = Array(temp_exemptions)
      new_farm_exemptions = Array(params[:temp_exemptions])

      # Get non-farm exemptions from transient_registration
      current_non_farm_exemptions = current_exemptions.reject do |id|
        WasteExemptionsEngine::Bucket.farmer_bucket.exemption_ids.include?(id)
      end

      # Combine non-farm exemptions with only the new farm exemptions
      # This is to allow removing farm exemptions when the user deselects
      # them while keeping the non-farm exemptions that are not handled by this form
      attributes = { temp_exemptions: (current_non_farm_exemptions + new_farm_exemptions).uniq.sort }

      super(attributes)
    end
  end
end
