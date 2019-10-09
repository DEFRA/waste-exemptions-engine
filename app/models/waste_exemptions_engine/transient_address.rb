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

    def valid_x_and_y?
      return false if x.blank? || y.blank?
      return false if x == 0.0 || y == 0.0

      true
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
      update_x_and_y
      update_grid_reference
      update_area_from_x_and_y if area.blank?

      save!
    end

    def update_x_and_y
      return if valid_x_and_y?

      result = DetermineXAndYService.run(grid_reference: grid_reference, postcode: postcode)
      self.x = result[:x]
      self.y = result[:y]
    end

    def update_grid_reference
      return unless valid_x_and_y?
      return unless grid_reference.blank?

      self.grid_reference = DetermineGridReferenceService.run(easting: x, northing: y)
    end

    def update_area_from_x_and_y
      return unless valid_x_and_y?

      self.area = AreaLookupService.run(easting: x, northing: y)
    end
  end
end
