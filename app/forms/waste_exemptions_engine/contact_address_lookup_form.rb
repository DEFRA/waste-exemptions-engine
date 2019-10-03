# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressLookupForm < AddressLookupFormBase
    delegate :temp_contact_postcode, :contact_address, :business_type, to: :transient_registration

    alias existing_address contact_address
    alias postcode temp_contact_postcode

    validates :contact_address, "waste_exemptions_engine/address": true

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      contact_address = create_address(params[:contact_address][:uprn], :contact)

      super(contact_address: contact_address)
    end
  end
end
