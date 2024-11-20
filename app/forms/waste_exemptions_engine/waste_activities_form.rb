# frozen_string_literal: true

module WasteExemptionsEngine
  class WasteActivitiesForm < BaseForm
    delegate :temp_waste_activities, to: :transient_registration

    validates :temp_waste_activities, "waste_exemptions_engine/waste_activities": true

    def submit(params)
      attributes = { temp_waste_activities: params[:temp_waste_activities] }

      super(attributes)
    end
  end
end
