# frozen_string_literal: true

module WasteExemptionsEngine
  module SiteAddressForm

    private

    def existing_postcode
      @registration.interim.site_postcode
    end

    def existing_address
      @registration.site_address
    end

    def address_type
      Address.address_types[:site]
    end
  end
end
