# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteSiteAddressLookupFormsController < AddressLookupFormsController
    def new
      super(MultisiteSiteAddressLookupForm, "multisite_site_address_lookup_form")
    end

    def create
      super(MultisiteSiteAddressLookupForm, "multisite_site_address_lookup_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:multisite_site_address_lookup_form, {}).permit(temp_site_address: [:uprn])
    end
  end
end
