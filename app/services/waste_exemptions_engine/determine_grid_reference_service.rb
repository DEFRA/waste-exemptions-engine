# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineGridReferenceService < BaseService
    # Easting and northing is just another name for x & y. We've gone with
    # easting and northing here purely to keep rubocop happy!
    def run(easting:, northing:)
      grid_reference_from_easting_northing(easting, northing)
    end

    private

    def grid_reference_from_easting_northing(easting, northing)
      return nil if easting.blank? || northing.blank?

      location = os_map_ref_location("#{easting}, #{northing}")

      location.map_reference
    rescue StandardError => e
      handle_error(e, "Easting & Northing to grid reference failed:\n #{e}", x: easting, y: northing)
      ""
    end

    def os_map_ref_location(coordinates)
      OsMapRef::Location.for(coordinates)
    end

    def handle_error(error, message, metadata)
      Airbrake.notify(error, metadata) if defined?(Airbrake)
      Rails.logger.error(message)
    end
  end
end
