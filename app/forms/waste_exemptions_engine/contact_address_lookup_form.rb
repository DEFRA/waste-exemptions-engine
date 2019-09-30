# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressLookupForm < AddressLookupFormBase
    delegate :temp_contact_postcode, :contact_address, :business_type, to: :transient_registration

    alias existing_address contact_address
    alias postcode temp_contact_postcode

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      contact_address = create_address(params[:temp_address], :contact)

      self.temp_address = contact_address

      super(contact_address: contact_address)
    end
  end
end
