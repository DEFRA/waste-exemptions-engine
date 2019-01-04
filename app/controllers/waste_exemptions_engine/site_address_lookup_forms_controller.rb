# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressLookupFormsController < AddressLookupFormsController
    def new
      super(SiteAddressLookupForm, "site_address_lookup_form")
    end

    def create
      super(SiteAddressLookupForm, "site_address_lookup_form")
    end
  end
end
