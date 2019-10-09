# frozen_string_literal: true

module WasteExemptionsEngine
  class PopulateAddressXAndYService < BaseService
    def run(address:)
      return if address.grid_reference.blank? && address.postcode.blank?

      @address = address

      # Preference is to take it from the grid reference if available as it
      # doesn't require a call to an external service, and is likely to be more
      # accurate. If that can't be done or fails, then try the postcode
      x_and_y_from_postcode unless x_and_y_from_grid_reference
    end

    private

    def x_and_y_from_grid_reference
      return false if @address.grid_reference.blank?

      location = os_map_ref_location(@address.grid_reference)
      @address.x = location.easting.to_f
      @address.y = location.northing.to_f

      true
    rescue OsMapRef::Error => e
      @address.x = 0.00
      @address.y = 0.00
      handle_error(e, "Grid reference to x & y failed:\n #{e}", grid_reference: @address.grid_reference)

      false
    end

    def x_and_y_from_postcode
      return if @address.postcode.blank?

      results = AddressFinderService.new(@address.postcode).search_by_postcode

      error_from_postcode_lookup_for_x_and_y_update(results) && return if results.is_a?(Symbol)
      no_result_from_postcode_lookup_for_x_and_y_update && return if results.empty?

      @address.x = results.first["x"].to_f
      @address.y = results.first["y"].to_f
    end

    def error_from_postcode_lookup_for_x_and_y_update(results)
      @address.x = 0.0
      @address.y = 0.0
      message = "Postcode to x & y failed:\n #{results}"
      handle_error(StandardError.new(message), message, postcode: @address.postcode)
    end

    def no_result_from_postcode_lookup_for_x_and_y_update
      @address.x = 0.0
      @address.y = 0.0
      message = "Postcode to x & y returned no results"
      handle_error(StandardError.new(message), message, postcode: @address.postcode)
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
