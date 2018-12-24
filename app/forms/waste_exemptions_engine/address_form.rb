# frozen_string_literal: true

module WasteExemptionsEngine
  module AddressForm
    include CanNavigateFlexibly

    attr_accessor :addresses
    attr_accessor :postcode

    # Methods which are called in this class but defined in subclasses
    # We should throw descriptive errors in case an additional subclass of ManualAddressForm is ever added

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
