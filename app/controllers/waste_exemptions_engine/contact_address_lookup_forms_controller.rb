# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactAddressLookupFormsController < AddressLookupFormsController
    def new
      super(ContactAddressLookupForm, "contact_address_lookup_form")
    end

    def create
      super(ContactAddressLookupForm, "contact_address_lookup_form")
    end
  end
end
