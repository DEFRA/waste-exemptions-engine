# frozen_string_literal: true

module WasteExemptionsEngine
  module WasteActivitiesFormsHelper
    def all_categories
      WasteActivity::ACTIVITY_CATEGORIES.keys
    end

    def category_activities(category)
      WasteActivity.where(category: category)
    end

    def exemption_codes_for_activity(activity)
      Exemption.for_waste_activities(activity).order(:code).map(&:code).join(", ")
    end
  end
end
