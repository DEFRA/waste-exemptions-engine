# frozen_string_literal: true

module WasteExemptionsEngine
  class WasteActivitiesFormsController < FormsController
    def new
      super(WasteActivitiesForm, "waste_activities_form")
    end

    def create
      super(WasteActivitiesForm, "waste_activities_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:waste_activities_form, {}).permit(temp_waste_activities: [])
    end
  end
end
