# frozen_string_literal: true

module WasteExemptionsEngine
  class ConfirmFarmExemptionsForm < BaseForm
    delegate :exemption_ids,
             :temp_exemptions,
             :temp_add_additional_non_bucket_exemptions,
             to: :transient_registration

    validates :temp_add_additional_non_bucket_exemptions, "defra_ruby/validators/true_false": true

    def initialize(transient_registration)
      transient_registration.temp_add_additional_non_bucket_exemptions = nil

      super
    end

    def submit(params)
      # When user opts out of additional non-farm exemptions
      if params[:temp_add_additional_non_bucket_exemptions] == "false"

        # Keep only farm exemptions in temp_exemptions
        farm_only_exemptions = temp_exemptions.select do |id|
          WasteExemptionsEngine::Bucket.farmer_bucket.exemption_ids.include?(id)
        end

        params.merge!(
          exemption_ids: farm_only_exemptions,
          temp_exemptions: farm_only_exemptions
        )
      end

      super
    end
  end
end
