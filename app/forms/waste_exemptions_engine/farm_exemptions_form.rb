# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmExemptionsForm < BaseForm
    delegate :temp_exemptions, :temp_farm_exemptions, :temp_activity_exemptions, to: :transient_registration

    def submit(params)
      # Set farm exemptions and combine with activity exemptions for temp_exemptions
      new_farm_exemptions = Array(params[:temp_exemptions])
      total_exemptions = if temp_confirm_exemptions == false && transient_registration.farm_affiliated?
                           new_farm_exemptions + Array(temp_activity_exemptions)
                         else
                           new_farm_exemptions
                         end

      attributes = {
        temp_farm_exemptions: params[:temp_exemptions],
        temp_exemptions: total_exemptions.uniq
      }

      super(attributes)
    end
  end
end
