# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineEastingAndNorthingService < BaseService
    def run(grid_reference:, postcode:)
      @result = { easting: nil, northing: nil }

      # Preference is to take it from the grid reference if available as it
      # doesn't require a call to an external service, and is likely to be more
      # accurate. If that can't be done or fails, then try the postcode
      easting_and_northing_from_grid_reference(grid_reference) ||
        easting_and_northing_from_postcode(postcode)

      @result
    end

    private

    def easting_and_northing_from_grid_reference(grid_reference)
      return false if grid_reference.blank?

      location = os_map_ref_location(grid_reference)
      @result[:easting] = location.easting.to_f
      @result[:northing] = location.northing.to_f

      true
    rescue StandardError => e
      default_do_not_fetch_again_coordinates
      handle_error(e, "Grid reference to easting and northing failed:\n #{e}", grid_reference: grid_reference)

      false
    end

    def easting_and_northing_from_postcode(postcode)
      return if postcode.blank?

      response = DefraRuby::Address::EaAddressFacadeV1Service.run(postcode)

      if response.successful?
        @result[:easting] = response.results.first["x"].to_f
        @result[:northing] = response.results.first["y"].to_f

        return
      end

      no_match_from_postcode_lookup(postcode) && return if response.error.is_a?(DefraRuby::Address::NoMatchError)

      error_from_postcode_lookup(postcode, response.error)
    end

    def no_match_from_postcode_lookup(postcode)
      default_do_not_fetch_again_coordinates

      message = "Postcode to easting and northing returned no results"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def error_from_postcode_lookup(postcode, error)
      default_do_not_fetch_again_coordinates

      message = "Postcode to easting and northing errored: #{error.message}"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def os_map_ref_location(coordinates)
      OsMapRef::Location.for(coordinates)
    end

    def handle_error(error, message, metadata)
      Airbrake.notify(error, metadata) if defined?(Airbrake)
      Rails.logger.error(message)
    end

    def default_do_not_fetch_again_coordinates
      @result[:easting] = 0.00
      @result[:northing] = 0.00
    end
  end
end
