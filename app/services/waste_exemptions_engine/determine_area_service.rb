# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineAreaService < BaseService
    def run(easting:, northing:)
      response = DefraRuby::Area::PublicFaceAreaService.run(easting, northing)

      return response.areas.first.long_name if response.successful?
      return "Outside England" if response.error.instance_of?(DefraRuby::Area::NoMatchError)

      handle_error(response.error, easting, northing)
      nil
    end

    private

    def handle_error(error, easting, northing)
      Airbrake.notify(error, easting: easting, northing: northing) if defined? Airbrake
      Rails.logger.error "Area lookup failed:\n #{error}"
    end
  end
end
