# frozen_string_literal: true

module WasteExemptionsEngine
  module CanRestrictSiteLocationsToEngland
    private

    def restrict_site_locations_to_england?
      FeatureToggle.active?(:restrict_site_locations_to_england) &&
        !WasteExemptionsEngine.configuration.host_is_back_office?
    end

    def site_location_allowed?(grid_reference: nil, easting: nil, northing: nil)
      return true unless restrict_site_locations_to_england?

      CheckSiteLocationIsInEnglandService.run(
        grid_reference:,
        easting:,
        northing:
      )
    end
  end
end
