# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineGridReferenceService < BaseService
    # Easting and northing is just another name for x & y. We've gone with
    # easting and northing here purely to keep rubocop happy!
    def run(easting:, northing:)
      return unless valid_arguments?(easting, northing)

      grid_reference_from_easting_northing(easting, northing)
    end

    private

    def valid_arguments?(easting, northing)
      return false unless valid_argument?(easting)
      return false unless valid_argument?(northing)

      true
    end

    def valid_argument?(argument)
      return false unless argument.is_a?(Numeric)
      return false unless argument.positive?

      true
    end

    def grid_reference_from_easting_northing(easting, northing)
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
