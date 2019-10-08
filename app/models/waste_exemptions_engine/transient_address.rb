# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class TransientAddress < ActiveRecord::Base
    self.table_name = "transient_addresses"

    include CanBeLocatedByGridReference

    belongs_to :transient_registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    after_create :update_x_and_y, :update_grid_reference, :update_area

    def address_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at")
    end

    def update_x_and_y
      return unless site?
      return unless x.blank? || y.blank?

      update_x_and_y_from_grid_reference if auto?
      update_x_and_y_from_postcode if manual?

      save!
    end

    def update_grid_reference
      return unless site?
      return unless grid_reference.blank?

      update_grid_reference_from_x_and_y

      save!
    end

    def update_area
      return unless site?

      update_area_from_x_and_y

      save!
    end

    def update_area_from_x_and_y
      return if x.blank? || y.blank?

      # The AreaLookup service handles errors and notifies Errbit in the event
      # of an error. This is why unlike other methods we don't have a rescue here
      self.area = AreaLookupService.run(easting: x, northing: y)
    end

    def update_grid_reference_from_x_and_y
      return if x.blank? || y.blank?

      location = OsMapRef::Location.for("#{x}, #{y}")
      self.grid_reference = location.map_reference
    rescue OsMapRef::Error => e
      self.grid_reference = ""
      handle_error(e, "X & Y to grid reference failed:\n #{e}", x: x, y: y)
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

    def self.create_from_address_finder_data(data, address_type)
      data = data.except("address").except("state_date")
      data["uprn"] = data["uprn"].to_s
      data["x"] = data["x"].to_f
      data["y"] = data["y"].to_f

      if address_type == TransientAddress.address_types[:site]
        data = add_site_details(data, TransientAddress.modes[:lookup])
      end

      create_address(data, address_type, TransientAddress.modes[:lookup])
    end

    def self.create_from_manual_entry_data(data, address_type)
      if address_type == TransientAddress.address_types[:site]
        data = add_site_details(data, TransientAddress.modes[:manual])
      end

      create_address(data, address_type, TransientAddress.modes[:manual])
    end

    def self.create_from_grid_reference_data(data, address_type)
      if address_type == TransientAddress.address_types[:site]
        data = add_site_details(data, TransientAddress.modes[:auto])
      end

      create_address(data, address_type, TransientAddress.modes[:auto])
    end

    private_class_method def self.create_address(data, address_type, mode)
      data["address_type"] = address_type
      data["mode"] = mode

      TransientAddress.create(data)
    end

    private_class_method def self.add_site_details(data, mode)
      # Add x & y dependent on how the site was entered
      data = update_xy_from_grid_reference(data) if mode == TransientAddress.modes[:auto]
      data = update_xy_from_postcode(data) if mode == TransientAddress.modes[:manual]

      # Add the grid reference for sites entered using an address
      data = update_grid_reference_from_xy(data) unless mode == TransientAddress.modes[:auto]

      # Add the EA administrative area
      data = update_area_from_xy(data)

      data
    end

    private_class_method def self.update_xy_from_postcode(data)
      return nil unless data

      postcode = data[:postcode]
      results = AddressFinderService.new(postcode).search_by_postcode if postcode.present?

      return data if results.is_a?(Symbol)

      if results&.length&.positive?
        data["x"] = results.first["x"].to_f
        data["y"] = results.first["y"].to_f
      end

      data
    end

    private_class_method def self.update_xy_from_grid_reference(data)
      return nil unless data

      begin
        location = OsMapRef::Location.for(data[:grid_reference])
        data["x"] = location.easting.to_f
        data["y"] = location.northing.to_f
      rescue OsMapRef::Error
        data["x"] = 0.00
        data["y"] = 0.00
      end

      data
    end

    private_class_method def self.update_grid_reference_from_xy(data)
      return nil unless data

      begin
        location = OsMapRef::Location.for("#{data['x']}, #{data['y']}")
        data["grid_reference"] = location.map_reference
      rescue OsMapRef::Error
        data["grid_reference"] = nil
      end

      data
    end

    private_class_method def self.update_area_from_xy(data)
      return data unless data
      return data if data["x"].nil? || data["y"].nil?

      data["area"] = AreaLookupService.run(easting: data["x"], northing: data["y"])

      data
    end
  end
end
