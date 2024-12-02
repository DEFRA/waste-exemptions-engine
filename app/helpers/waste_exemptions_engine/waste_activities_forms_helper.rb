# frozen_string_literal: true

module WasteExemptionsEngine
  module WasteActivitiesFormsHelper
    def all_categories
      WasteActivity::ACTIVITY_CATEGORIES.keys
    end

    def category_activities(category)
      WasteActivity.where(category: category)
    end
  end
end
