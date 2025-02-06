# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_farm_exemptions, :temp_activity_exemptions, to: :transient_registration

    def submit(params)
      # Set farm exemptions and combine with activity exemptions for temp_exemptions
      attributes = {
        temp_farm_exemptions: params[:temp_exemptions],
        temp_exemptions: Array(params[:temp_exemptions]) + Array(temp_activity_exemptions)
      }

      super(attributes)
    end
  end
end
