# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, :temp_farm_exemptions, :temp_activity_exemptions, :temp_confirm_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      new_activity_exemptions = Array(params[:temp_exemptions])
      total_exemptions = if temp_confirm_exemptions == false && transient_registration.farm_affiliated?
                           new_activity_exemptions + Array(temp_farm_exemptions)
                         else
                           new_activity_exemptions
                         end



      attributes = {
        temp_activity_exemptions: new_activity_exemptions,
        temp_exemptions: total_exemptions.uniq
      }

      super(attributes)
    end
  end
end
