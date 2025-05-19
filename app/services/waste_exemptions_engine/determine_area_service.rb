# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineAreaService < BaseService
    def run(easting:, northing:)
      area = EaPublicFaceArea.find_by_coordinates(easting, northing)

      (area || EaPublicFaceArea.outside_england_area).name
    end
  end
end
