# frozen_string_literal: true

module WasteExemptionsEngine
  module Analytics
    class PageView < ApplicationRecord
      self.table_name = "analytics_page_views"

      belongs_to :user_journey, class_name: "WasteExemptionsEngine::Analytics::UserJourney"
    end
  end
end
