# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteSiteAddressLookupForm < AddressLookupFormBase
    delegate :temp_site_postcode, to: :transient_registration

    attr_accessor :temp_site_address

    alias postcode temp_site_postcode

    validates :temp_site_address, "waste_exemptions_engine/address": true

    def submit(params)
      site_address_params = params.fetch(:temp_site_address, {})
      address_attributes = get_address_data(site_address_params[:uprn], :site)

      return false unless address_attributes

      # Create the site address directly in the transient registration
      transient_registration.transient_addresses.create!(
        address_attributes.merge(
          address_type: "site",
          mode: "lookup"
        )
      )

      true
    end
  end
end
