# frozen_string_literal: true

module WasteExemptionsEngine
  class WasteActivity < ApplicationRecord
    self.table_name = "waste_activities"

    # reusing categories defined in Exemption model
    enum category: { using_waste: 0, treating_waste: 1, disposing_of_waste: 2, storing_waste: 3 }
  end
end
