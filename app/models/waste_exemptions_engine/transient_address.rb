# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class TransientAddress < ActiveRecord::Base
    self.table_name = "transient_addresses"

    include CanBeLocatedByGridReference

    belongs_to :transient_registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

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

    def self.create_from_manual_entry_data(data, address_type)
      data = update_xy_from_postcode(data) if address_type == TransientAddress.address_types[:site]

      create_address(data, address_type, TransientAddress.modes[:manual])
    end

    def self.create_from_grid_reference_data(data, address_type)
      data = update_xy_from_grid_reference(data)

      create_address(data, address_type, TransientAddress.modes[:auto])
    end

    private_class_method def self.create_address(data, address_type, mode)
      data["address_type"] = address_type
      data["mode"] = mode

      TransientAddress.create(data)
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
        data["x"] = nil
        data["y"] = nil
      end

      data
    end
  end
end
