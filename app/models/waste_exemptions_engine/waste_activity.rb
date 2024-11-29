# frozen_string_literal: true

module WasteExemptionsEngine
  class WasteActivity < ApplicationRecord
    self.table_name = "waste_activities"

    ACTIVITY_CATEGORIES = { using_waste: 0, disposing_of_waste: 2, treating_waste: 1, storing_waste: 3 }.freeze

    # reusing categories defined in Exemption model
    enum category: ACTIVITY_CATEGORIES
  end
end
