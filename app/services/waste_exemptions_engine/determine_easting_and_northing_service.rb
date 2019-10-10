# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineEastingAndNorthingService < BaseService
    def run(grid_reference:, postcode:)
      @result = { easting: nil, northing: nil }
      return @result unless valid_arguments?(grid_reference, postcode)

      # Preference is to take it from the grid reference if available as it
      # doesn't require a call to an external service, and is likely to be more
      # accurate. If that can't be done or fails, then try the postcode
      easting_and_northing_from_postcode(postcode) unless easting_and_northing_from_grid_reference(grid_reference)

      @result
    end

    private

    def valid_arguments?(grid_reference, postcode)
      grid_reference.present? || postcode.present?
    end

    def easting_and_northing_from_grid_reference(grid_reference)
      return false if grid_reference.blank?

      location = os_map_ref_location(grid_reference)
      @result[:easting] = location.easting.to_f
      @result[:northing] = location.northing.to_f

      true
    rescue StandardError => e
      @result[:easting] = 0.00
      @result[:northing] = 0.00
      handle_error(e, "Grid reference to easting and northing failed:\n #{e}", grid_reference: grid_reference)

      false
    end

    def easting_and_northing_from_postcode(postcode)
      return if postcode.blank?

      results = AddressFinderService.new(postcode).search_by_postcode

      if results.is_a?(Symbol)
        @result[:easting] = 0.0
        @result[:northing] = 0.0
        return
      end

      no_result_from_postcode_lookup(postcode) && return if results.empty?

      @result[:easting] = results.first["x"].to_f
      @result[:northing] = results.first["y"].to_f
    end

    def no_result_from_postcode_lookup(postcode)
      @result[:easting] = 0.0
      @result[:northing] = 0.0
      message = "Postcode to easting and northing returned no results"
      handle_error(StandardError.new(message), message, postcode: postcode)
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
