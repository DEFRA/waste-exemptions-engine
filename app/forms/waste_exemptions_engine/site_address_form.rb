# frozen_string_literal: true

module WasteExemptionsEngine
  module SiteAddressForm

    private

    def existing_postcode
      @enrollment.interim.site_postcode
    end

    def existing_address
      @enrollment.site_address
    end

    def address_type
      Address.address_types[:site]
    end
  end
end
