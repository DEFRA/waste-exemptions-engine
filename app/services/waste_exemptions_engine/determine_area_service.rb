# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineAreaService < BaseService
    def run(easting:, northing:)
      return nil unless valid_coordinates?(easting, northing)

      begin
        area = EaPublicFaceArea.find_by_coordinates(easting, northing)
        area ? area.name : "Outside England"
      rescue StandardError => e
        Airbrake.notify(e, easting: easting, northing: northing) if defined? Airbrake
        Rails.logger.error "Area lookup failed:\n #{e}"
        raise
      end
    end

    private

    def valid_coordinates?(easting, northing)
      easting.present? && northing.present? &&
        easting.to_f != 0 && northing.to_f != 0
    end
  end
end
