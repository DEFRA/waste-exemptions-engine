# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class TransientAddress < ActiveRecord::Base
    self.table_name = "transient_addresses"

    include CanBeLocatedByGridReference

    belongs_to :transient_registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    after_create :update_site_details, if: :site?

    def address_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at")
    end

    def self.create_from_address_finder_data(data, address_type)
      data = data.except("address").except("state_date")
      data["uprn"] = data["uprn"].to_s
      data["x"] = data["x"].to_f
      data["y"] = data["y"].to_f

      create_address(data, address_type, TransientAddress.modes[:lookup])
    end

    def self.create_from_grid_reference_data(data, address_type)
      create_address(data, address_type, TransientAddress.modes[:auto])
    end

    private_class_method def self.create_address(data, address_type, mode)
      data["address_type"] = address_type
      data["mode"] = mode

      TransientAddress.create(data)
    end

    private

    def update_site_details
      update_x_and_y_from_grid_reference if update_x_and_y?
      update_x_and_y_from_postcode if update_x_and_y?
      update_grid_reference_from_x_and_y if grid_reference.blank?
      update_area_from_x_and_y if area.blank?

      save!
    end

    def update_x_and_y?
      x.blank? || y.blank?
    end

    def update_x_and_y_from_grid_reference
      return if grid_reference.blank?

      location = OsMapRef::Location.for(grid_reference)
      self.x = location.easting.to_f
      self.y = location.northing.to_f
    rescue OsMapRef::Error => e
      self.x = 0.00
      self.y = 0.00
      handle_error(e, "Grid reference to x & y failed:\n #{e}", grid_reference: grid_reference)
    end

    def update_x_and_y_from_postcode
      return if postcode.blank?

      results = AddressFinderService.new(postcode).search_by_postcode

      error_from_postcode_lookup_for_x_and_y_update(results) && return if results.is_a?(Symbol)
      no_result_from_postcode_lookup_for_x_and_y_update && return if results.empty?

      self.x = results.first["x"].to_f
      self.y = results.first["y"].to_f
    end

    def update_grid_reference_from_x_and_y
      return if x.blank? || y.blank?

      location = OsMapRef::Location.for("#{x}, #{y}")
      self.grid_reference = location.map_reference
    rescue OsMapRef::Error => e
      self.grid_reference = ""
      handle_error(e, "X & Y to grid reference failed:\n #{e}", x: x, y: y)
    end

    def update_area_from_x_and_y
      return if x.blank? || y.blank?

      # The AreaLookup service handles errors and notifies Errbit in the event
      # of an error. This is why unlike other methods we don't have a rescue here
      self.area = AreaLookupService.run(easting: x, northing: y)
    end

    def error_from_postcode_lookup_for_x_and_y_update(results)
      self.x = 0.0
      self.y = 0.0
      message = "Postcode to x & y failed:\n #{results}"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def no_result_from_postcode_lookup_for_x_and_y_update
      self.x = 0.0
      self.y = 0.0
      message = "Postcode to x & y returned no results"
      handle_error(StandardError.new(message), message, postcode: postcode)
    end

    def handle_error(error, message, metadata)
      Airbrake.notify(error, metadata) if defined?(Airbrake)
      Rails.logger.error(message)
    end
  end
end
