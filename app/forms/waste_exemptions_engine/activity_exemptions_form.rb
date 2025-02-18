# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # Get the current exemptions and new non-farm exemptions
      current_exemptions = Array(temp_exemptions)
      new_non_farm_exemptions = Array(params[:temp_exemptions])

      # Get farm exemptions from transient_registration
      current_farm_exemptions = current_exemptions.select do |id|
        WasteExemptionsEngine::Bucket.farmer_bucket.exemption_ids.include?(id)
      end

      # Combine farm exemptions with only the new non-farm exemptions
      # This is to allow removing non-farm exemptions when the user deselects
      # them while keeping the farm exemptions that are not handled by this form
      attributes = { temp_exemptions: (current_farm_exemptions + new_non_farm_exemptions).uniq.sort }

      super(attributes)
    end
  end
end
