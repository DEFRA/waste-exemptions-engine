# frozen_string_literal: true

module WasteExemptionsEngine
  module AddressForm
    # Methods which are called in this class but defined in subclasses
    # We should throw descriptive errors in case an additional subclass of ManualAddressForm is ever added

    def add_or_replace_address(address, existing_addresses)
      # Update the registration's nested addresses, replacing any existing address of the same type
      updated_addresses = existing_addresses
      matched_address = updated_addresses.find(existing_address.id) if existing_address

      if matched_address
        updated_addresses.delete(matched_address)
        matched_address.delete
      end

      updated_addresses << address if address

      updated_addresses
    end

    def existing_postcode
      implemented_in_subclass
    end

    def existing_address
      implemented_in_subclass
    end

    def address_type
      implemented_in_subclass
    end

    def implemented_in_subclass
      raise NotImplementedError, "This #{self.class} cannot respond to:"
    end
  end
end
