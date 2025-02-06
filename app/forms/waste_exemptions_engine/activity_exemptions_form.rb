# frozen_string_literal: true

module WasteExemptionsEngine
  class ActivityExemptionsForm < BaseForm
    delegate :temp_exemptions, :temp_farm_exemptions, :temp_activity_exemptions, :temp_confirm_exemptions, to: :transient_registration

    validates :temp_exemptions, "waste_exemptions_engine/exemptions": true

    def submit(params)
      # If temp_confirm_exemptions is true, we're confirming the selection
      # Otherwise, we're adding to it
      new_activity_exemptions = if temp_confirm_exemptions
                                 Array(params[:temp_exemptions])
                               else
                                 Array(temp_activity_exemptions) + Array(params[:temp_exemptions])
                               end

      attributes = {
        temp_activity_exemptions: new_activity_exemptions,
        temp_exemptions: Array(temp_farm_exemptions) + new_activity_exemptions
      }

      super(attributes)
    end
  end
end
