# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineAreaService < BaseService
    def run(easting:, northing:)
      return nil unless valid_coordinates?(easting, northing)

      area = EaPublicFaceArea.find_by_coordinates(easting, northing)

      area ? area.name : "Outside England"
    end

    private

    def valid_coordinates?(easting, northing)
      easting.present? && northing.present? &&
        easting.to_f != 0 && northing.to_f != 0
    end
  end
end
