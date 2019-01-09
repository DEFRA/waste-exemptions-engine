# frozen_string_literal: true

module WasteExemptionsEngine
  module SiteAddressForm

    private

    def existing_postcode
      @transient_registration.temp_site_postcode
    end

    def existing_address
      @transient_registration.site_address
    end

    def address_type
      TransientAddress.address_types[:site]
    end
  end
end
