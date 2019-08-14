# frozen_string_literal: true

module WasteExemptionsEngine
  class AddressLookupForm < BaseForm
    include AddressForm

    attr_accessor :temp_addresses
    attr_accessor :temp_address

    # After callbacks are called in reverse order, so the last one in the list is called first
    set_callback :initialize, :after, :preselect_existing_address
    set_callback :initialize, :after, :look_up_addresses
    set_callback :initialize, :after, :set_postcode

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      new_address = create_address(params[:temp_address])

      self.temp_address = new_address
      attributes = {
        transient_addresses: add_or_replace_address(new_address, @transient_registration.transient_addresses)
      }

      super(attributes, params[:token])
    end

    validates :temp_address, "waste_exemptions_engine/address": true

    private

    def set_postcode
      self.postcode = existing_postcode
    end

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

    def create_address(selected_address_uprn)
      return if selected_address_uprn.blank?

      data = temp_addresses.detect { |address| address["uprn"] == selected_address_uprn.to_i }
      return unless data

      address = TransientAddress.create_from_address_finder_data(data, address_type)

      address
    end
  end
end
