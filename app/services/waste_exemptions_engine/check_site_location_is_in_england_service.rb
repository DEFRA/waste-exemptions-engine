# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckSiteLocationIsInEnglandService < BaseService
    def run(grid_reference: nil, easting: nil, northing: nil)
      coordinates = determine_coordinates(grid_reference:, easting:, northing:)
      return true unless valid_coordinates?(coordinates[:easting], coordinates[:northing])

      area = DetermineAreaService.run(
        easting: coordinates[:easting],
        northing: coordinates[:northing]
      )

      area != EaPublicFaceArea::OUTSIDE_ENGLAND_NAME
    rescue StandardError
      true
    end

    private

    def determine_coordinates(grid_reference:, easting:, northing:)
      if easting.present? && northing.present?
        { easting: easting.to_f, northing: northing.to_f }
      else
        DetermineEastingAndNorthingService.run(grid_reference:, postcode: nil)
      end
    end

    def valid_coordinates?(easting, northing)
      easting.present? && northing.present? &&
        easting.to_f != 0 && northing.to_f != 0
    end
  end
end
