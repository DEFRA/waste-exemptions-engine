# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # Get the current exemptions and new farm exemptions
      current_exemptions = Array(temp_exemptions)
      new_farm_exemptions = Array(params[:temp_exemptions])

      # Keep non-farm exemptions and add new farm exemptions
      non_farm_exemptions = current_exemptions.reject do |id|
        WasteExemptionsEngine::Bucket.farmer_bucket.exemption_ids.include?(id)
      end

      # Update with new exemptions (non-farm + selected farm)
      attributes = { temp_exemptions: (non_farm_exemptions + new_farm_exemptions).uniq.sort }

      super(attributes)
    end
  end
end
