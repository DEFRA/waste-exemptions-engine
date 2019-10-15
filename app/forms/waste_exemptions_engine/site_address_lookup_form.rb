# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressLookupForm < AddressLookupFormBase
    delegate :temp_site_postcode, :site_address, to: :transient_registration

    alias existing_address site_address
    alias postcode temp_site_postcode

    validates :site_address, "waste_exemptions_engine/address": true

    def submit(params)
      site_address_params = params.fetch(:site_address, {})
      site_address_attributes = get_address_data(site_address_params[:uprn], :site)

      super(site_address_attributes: site_address_attributes)
    end
  end
end
