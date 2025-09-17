# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteSiteAddressLookupForm < AddressLookupFormBase
    delegate :temp_site_postcode, to: :transient_registration

    # This virtual attribute is validated using AddressValidator and populated
    # from incoming params (e.g. { site_address: { uprn: "123" } })
    attr_accessor :site_address

    alias postcode temp_site_postcode

    validates :site_address, "waste_exemptions_engine/address": true

    def submit(params)
      site_address_params = params.fetch(:site_address, {})
      @site_address = site_address_params

      address_attributes = get_address_data(site_address_params[:uprn], :site)

      return false unless valid? && address_attributes.present?

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
