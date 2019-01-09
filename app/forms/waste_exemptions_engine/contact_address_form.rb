# frozen_string_literal: true

module WasteExemptionsEngine
  module ContactAddressForm

    private

    def existing_postcode
      @transient_registration.temp_contact_postcode
    end

    def existing_address
      @transient_registration.contact_address
    end

    def address_type
      TransientAddress.address_types[:contact]
    end
  end
end
