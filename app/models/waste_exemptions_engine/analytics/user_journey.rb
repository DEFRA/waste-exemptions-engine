module WasteExemptionsEngine
  class Analytics
    class UserJourney < ApplicationRecord
      self.table_name = "user_journeys"
    end
  end
end
