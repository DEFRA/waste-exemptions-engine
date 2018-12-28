# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class Address < ActiveRecord::Base
    belongs_to :enrollment

    self.table_name = "addresses"

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    def self.create_from_address_finder_data(data, address_type)
      data = data.except("address").except("state_date")
      data["uprn"] = data["uprn"].to_s
      data["x"] = data["x"].to_f
      data["y"] = data["y"].to_f

      create_address(data, address_type, Address.modes[:lookup])
    end

    def self.create_from_manual_entry_data(data, address_type)
      create_address(data, address_type, Address.modes[:manual])
    end

    def self.create_from_grid_reference_data(data, address_type)
      data = update_xy_from_grid_reference(data)

      create_address(data, address_type, Address.modes[:auto])
    end

    private_class_method def self.create_address(data, address_type, mode)
      data["address_type"] = address_type
      data["mode"] = mode

      Address.create(data)
    end

    private_class_method def self.update_xy_from_grid_reference(data)
      return nil unless data

      begin
        location = OsMapRef::Location.for(data[:grid_reference])
        data["x"] = location.easting.to_f
        data["y"] = location.northing.to_f
      rescue OsMapRef::Error
        data["x"] = nil
        data["y"] = nil
      end

      data
    end
  end
end
