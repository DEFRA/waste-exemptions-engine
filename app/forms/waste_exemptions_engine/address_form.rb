# frozen_string_literal: true

module WasteExemptionsEngine
  module AddressForm
    include CanNavigateFlexibly

    attr_accessor :postcode

    # Methods which are called in this class but defined in subclasses
    # We should throw descriptive errors in case an additional subclass of ManualAddressForm is ever added

    def add_or_replace_address(address, existing_addresses)
      # Update the enrollment's nested addresses, replacing any existing address of the same type
      updated_addresses = existing_addresses
      updated_addresses.delete(existing_address) if existing_address
      updated_addresses << address

      updated_addresses
    end

    def create_address(_data)
      implemented_in_subclass
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
