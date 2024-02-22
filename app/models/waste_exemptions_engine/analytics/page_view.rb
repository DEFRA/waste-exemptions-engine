module WasteExemptionsEngine
  class Analytics
    class PageView < ApplicationRecord
      self.table_name = "page_views"

      belongs_to :user_journey
    end
  end
end
