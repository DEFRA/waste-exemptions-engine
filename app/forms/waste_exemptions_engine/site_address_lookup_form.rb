# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressLookupForm < AddressLookupFormBase
    delegate :temp_site_postcode, :site_address, to: :transient_registration

    alias existing_address site_address
    alias postcode temp_site_postcode

    validates :site_address, "waste_exemptions_engine/address": true

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      site_address = create_address(params[:site_address][:uprn], :site)

      super(site_address: site_address)
    end
  end
end
