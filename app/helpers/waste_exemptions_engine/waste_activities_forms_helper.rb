# frozen_string_literal: true

module WasteExemptionsEngine
  module WasteActivitiesFormsHelper
    def waste_activities_sorted
      category_positions = {
        "using_waste" => 1,
        "disposing_of_waste" => 2,
        "treating_waste" => 3,
        "storing_waste" => 4
      }

      waste_activities = WasteActivity.all
      # sort by category and then by id
      waste_activities.to_a.sort_by { |activity| [category_positions[activity.category], activity.id] }
    end
  end
end
