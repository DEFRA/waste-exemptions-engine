# frozen_string_literal: true

module WasteExemptionsEngine
  class SiteAddressLookupForm < AddressLookupFormBase
    delegate :temp_site_postcode, to: :transient_registration

    # This virtual attribute is validated using AddressValidator and populated
    # from incoming params (e.g. { site_address: { uprn: "123" } })
    attr_accessor :site_address

    alias postcode temp_site_postcode

    # For the view - returns the actual Address object or nil
    def existing_address
      transient_registration.site_address
    end

    validates :site_address, "waste_exemptions_engine/address": true

    def submit(params)
      site_address_params = params.fetch(:site_address, {})
      # Set for validation (expects a hash with :uprn or :postcode)
      @site_address = site_address_params

      address_attributes = get_address_data(site_address_params[:uprn], :site)

      return false unless valid? && address_attributes.present?

      if transient_registration.multisite_registration?
        transient_registration.transient_addresses.create!(
          address_attributes.merge(
            address_type: "site",
            mode: "lookup"
          )
        )
        true
      else
        super(site_address_attributes: address_attributes)
      end
    end
  end
end
