# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressLookupFormsController < AddressLookupFormsController
    def new
      super(SiteAddressLookupForm, "site_address_lookup_form")
    end

    def create
      super(SiteAddressLookupForm, "site_address_lookup_form")
    end

    private

    def transient_registration_attributes
      params.require(:site_address_lookup_form).permit(site_address: [:uprn])
    end
  end
end
