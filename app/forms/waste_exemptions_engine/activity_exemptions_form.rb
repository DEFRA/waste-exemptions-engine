# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # This form handles all non-farm exemptions; the param holds what has been selected in the form
      selected_non_farm_exemptions = params[:temp_exemptions] || []

      # Combine any previously selected farm exemptions with non-farm exemptions selected on this form
      attributes = { temp_exemptions: (farmer_bucket_exemptions + selected_non_farm_exemptions).uniq.sort }

      super(attributes)
    end

    private

    # This form doesn't handle farm exemptions if the order has a farmer bucket.
    # Read them from the transient_registration.
    def farmer_bucket_exemptions
      return [] if @transient_registration.order&.bucket.nil?

      temp_exemptions.select do |id|
        WasteExemptionsEngine::Bucket.farmer_bucket.exemption_ids.include?(id)
      end
    end
  end
end
