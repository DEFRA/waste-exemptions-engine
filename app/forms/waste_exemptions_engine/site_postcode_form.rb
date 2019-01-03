# frozen_string_literal: true

module WasteExemptionsEngine
  class SitePostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    private

    def existing_postcode
      @enrollment.interim.site_postcode
    end
  end
end
