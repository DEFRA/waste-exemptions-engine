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

      in_england = CheckSiteLocationIsInEnglandService.run(
        grid_reference:,
        easting:,
        northing:
      )

      # If we can't determine if the location, prevent blocking flow
      in_england.nil? || in_england
    end
  end
end
