# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressLookupFormBase < BaseForm
    include CanCreateAddressFromFinderData

    attr_accessor :temp_addresses, :temp_address

    validates :temp_address, "waste_exemptions_engine/address": true

    def initialize(registration)
      super

      look_up_addresses
      preselect_existing_address
    end

    private

    # Look up addresses based on the postcode
    def look_up_addresses
      if postcode.present?
        address_finder = AddressFinderService.new(postcode)
        self.temp_addresses = address_finder.search_by_postcode
      else
        self.temp_addresses = []
      end
    end

    # If an address has already been assigned to the registration, pre-select it
    def preselect_existing_address
      return unless can_preselect_address?

      selected_address = temp_addresses.detect { |address| address["uprn"].to_s == existing_address.uprn }
      self.temp_address = selected_address["uprn"] if selected_address.present?
    end

    def can_preselect_address?
      return false unless existing_address
      return false unless existing_address.uprn.present?

      true
    end
  end
end