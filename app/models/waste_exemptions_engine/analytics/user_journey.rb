# frozen_string_literal: true

module WasteExemptionsEngine
  module Analytics
    class UserJourney < ApplicationRecord
      self.table_name = "analytics_user_journeys"

      # Relationships
      has_many :page_views, class_name: "WasteExemptionsEngine::Analytics::PageView"

      # Validations
      validates :started_route, inclusion: { in: %w[DIGITAL ASSISTED_DIGITAL] }
      validates :token, presence: true

      serialize :registration_data, type: Hash, coder: JSON

      START_CUTOFF_PAGES = %w[
        location_form
        edit_exemptions_form
        front_office_edit_form
        confirm_renewal_form
      ].freeze

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

      scope :registrations, -> { where(journey_type: "NewRegistration") }
      scope :renewals, -> { where(journey_type: "RenewingRegistration") }
      scope :only_types, ->(journey_types) { where(journey_type: journey_types) }
      scope :started_digital, -> { where(started_route: "DIGITAL") }
      scope :started_assisted_digital, -> { where(started_route: "ASSISTED_DIGITAL") }
      scope :incomplete, -> { where(completed_at: nil) }
      scope :completed, -> { where.not(completed_at: nil) }
      scope :completed_digital, -> { where(completed_route: "DIGITAL") }
      scope :completed_assisted_digital, -> { where(completed_route: "ASSISTED_DIGITAL") }

      # rubocop:disable Metrics/BlockLength
      scope :passed_start_cutoff_page, lambda {
        # Subquery to check for the existence of the START_CUTOFF_PAGES in any PageView for the UserJourney
        start_cutoff_page_subquery = <<-SQL
          EXISTS (
            SELECT 1
            FROM analytics_page_views
            WHERE
              analytics_page_views.user_journey_id = analytics_user_journeys.id
              AND analytics_page_views.page IN ('#{START_CUTOFF_PAGES.join("', '")}')
          )
        SQL

        # Subquery to find the last PageView for each UserJourney
        last_page_not_cutoff_subquery = <<-SQL
          NOT EXISTS (
            SELECT 1
            FROM analytics_page_views as last_pages
            WHERE
              last_pages.user_journey_id = analytics_user_journeys.id
              AND last_pages.id = (
                SELECT id
                FROM analytics_page_views
                WHERE analytics_page_views.user_journey_id = last_pages.user_journey_id
                ORDER BY created_at DESC
                LIMIT 1
              )
              AND last_pages.page IN ('#{START_CUTOFF_PAGES.join("', '")}')
          )
        SQL

        where(start_cutoff_page_subquery).where(last_page_not_cutoff_subquery)
      }
      # rubocop:enable Metrics/BlockLength

      scope :date_range, lambda { |start_date, end_date|
        where("created_at >= :start AND created_at <= :end",
              start: start_date.beginning_of_day, end: end_date.end_of_day)
          .or(
            where(
              "completed_at IS NOT NULL AND completed_at >= :start AND completed_at <= :end AND created_at >= :start",
              start: start_date.beginning_of_day, end: end_date.end_of_day
            )
          )
      }

      def self.minimum_created_at
        minimum(:created_at)
      end

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

      def self.average_duration(user_journey_scope)
        durations = user_journey_scope.pluck(Arel.sql("EXTRACT(EPOCH FROM (updated_at - created_at))"))
        return 0 if durations.empty?

        durations.sum / durations.size
      end
    end
  end
end
