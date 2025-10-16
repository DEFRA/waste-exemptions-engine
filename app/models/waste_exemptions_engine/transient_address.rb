# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class TransientAddress < ApplicationRecord
    self.table_name = "transient_addresses"

    include CanBeLocatedByGridReference
    include HasDisplayableAddress

    belongs_to :transient_registration

    enum :address_type, { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum :mode, { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    before_create :assign_site_details, if: :site?

    def address_attributes
      attributes.except("id", "transient_registration_id", "created_at", "updated_at", "site_suffix")
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

    def assign_site_details
      AssignSiteDetailsService.run(address: self)
    end
  end
end
