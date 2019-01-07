# frozen_string_literal: true

module WasteExemptionsEngine
  module ContactAddressForm

    private

    def existing_postcode
      @registration.interim.contact_postcode
    end

    def existing_address
      @registration.contact_address
    end

    def address_type
      Address.address_types[:contact]
    end
  end
end
