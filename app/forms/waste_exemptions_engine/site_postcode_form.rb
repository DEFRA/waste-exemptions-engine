# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    private

    def existing_postcode
      @transient_registration.temp_site_postcode
    end
  end
end
