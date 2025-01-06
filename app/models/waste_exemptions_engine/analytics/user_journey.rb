# frozen_string_literal: true

module WasteExemptionsEngine
  module Analytics
    class UserJourney < ApplicationRecord
      self.table_name = "analytics_user_journeys"
      self.primary_key = "id"

      # Relationships
      has_many :page_views, class_name: "WasteExemptionsEngine::Analytics::PageView"

      # Validations
      validates :started_route, inclusion: { in: %w[DIGITAL ASSISTED_DIGITAL] }
      validates :token, presence: true

      serialize :registration_data, type: Hash, coder: JSON

      COMPLETION_PAGES = %w[
        register_in_wales_form
        register_in_scotland_form
        register_in_northern_ireland_form
        front_office_edit_complete_form
        front_office_edit_complete_no_changes_form
        back_office_edit_complete_form
        registration_complete_form
        renewal_complete_form
        deregistration_complete_full_form
        deregistration_complete_no_change_form
      ].freeze

      def complete_journey(transient_registration)
        route = WasteExemptionsEngine.configuration.host_is_back_office? ? "ASSISTED_DIGITAL" : "DIGITAL"
        update(
          completed_at: Time.zone.now,
          completed_route: route,
          registration_data: transient_registration.attributes.slice(
            "business_type",
            "type"
          )
        )
      end
    end
  end
end
