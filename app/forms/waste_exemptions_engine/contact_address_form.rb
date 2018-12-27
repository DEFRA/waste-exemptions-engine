# frozen_string_literal: true

module WasteExemptionsEngine
  module ContactAddressForm

    private

    def existing_postcode
      @enrollment.interim.contact_postcode
    end

    def existing_address
      @enrollment.contact_address
    end

    def address_type
      Address.address_types[:contact]
    end
  end
end
