# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressLookupForm < AddressLookupForm
    delegate :contact_address, to: :transient_registration

    validates :contact_address, "waste_exemptions_engine/address": true

    private

    def existing_postcode
      transient_registration.temp_contact_postcode
    end

    def address_type
      TransientAddress.address_types[:contact]
    end
  end
end
