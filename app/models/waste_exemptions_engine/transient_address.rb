# frozen_string_literal: true

require "os_map_ref"

module WasteExemptionsEngine
  class TransientAddress < ActiveRecord::Base
    self.table_name = "transient_addresses"

    include CanBeLocatedByGridReference

    belongs_to :transient_registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    after_create :update_site_details

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

    # Disabling the following cops for these reasons.
    #
    # The part of the code that tips the balance to being too complex is the
    # `if foo.blank? checks after each method call. Take them away and we're
    # fine.
    #
    # The first issue is if we move those checks into the methods, then the
    # complexity warnings move to them instead. We would argue that actually
    # neither this method, nor the methods we call here are actually that
    # complex and it would make things worse not better to break things up
    # further.
    #
    # Secondly we have a nice separation between what the checks represent. Here
    # our checks are determining whther we need to run the updates or not. The
    # update methods themselves don't care if the fields they are updating are
    # populated or not, they just care whether they have the data they need to
    # run.
    #
    # By splitting them up in this way we retain the flexibility to call these
    # methods to update the fields irrespectibe of their current state. And
    # we reduce what they need to know to just 'have i got the data I need'.
    #
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def update_site_details
      return unless site?

      update_x_and_y_from_grid_reference if x.blank? || y.blank?
      update_x_and_y_from_postcode if x.blank? || y.blank?
      update_grid_reference_from_x_and_y if grid_reference.blank?
      update_area_from_x_and_y if area.blank?

      save!
    end
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity

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
