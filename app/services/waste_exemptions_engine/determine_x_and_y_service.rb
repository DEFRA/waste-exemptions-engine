# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineXAndYService < BaseService
    def run(grid_reference:, postcode:)
      @result = { x: nil, y: nil }
      return @result if grid_reference.blank? && postcode.blank?

      # Preference is to take it from the grid reference if available as it
      # doesn't require a call to an external service, and is likely to be more
      # accurate. If that can't be done or fails, then try the postcode
      x_and_y_from_postcode(postcode) unless x_and_y_from_grid_reference(grid_reference)

      @result
    end

    private

    def x_and_y_from_grid_reference(grid_reference)
      return false if grid_reference.blank?

      location = os_map_ref_location(grid_reference)
      @result[:x] = location.easting.to_f
      @result[:y] = location.northing.to_f

      true
    rescue StandardError => e
      @result[:x] = 0.00
      @result[:y] = 0.00
      handle_error(e, "Grid reference to x & y failed:\n #{e}", grid_reference: grid_reference)

      false
    end

    def x_and_y_from_postcode(postcode)
      return if postcode.blank?

      results = AddressFinderService.new(postcode).search_by_postcode

      error_from_postcode_lookup_for_x_and_y_update(postcode, results) && return if results.is_a?(Symbol)
      no_result_from_postcode_lookup_for_x_and_y_update(postcode) && return if results.empty?

      @result[:x] = results.first["x"].to_f
      @result[:y] = results.first["y"].to_f
    end

    def error_from_postcode_lookup_for_x_and_y_update(postcode, results)
      @result[:x] = 0.0
      @result[:y] = 0.0
      message = "Postcode to x & y failed:\n #{results}"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def no_result_from_postcode_lookup_for_x_and_y_update(postcode)
      @result[:x] = 0.0
      @result[:y] = 0.0
      message = "Postcode to x & y returned no results"
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
