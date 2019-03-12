# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeForm < PostcodeForm

    private

    def existing_postcode
      @transient_registration.temp_site_postcode
    end
  end
end
