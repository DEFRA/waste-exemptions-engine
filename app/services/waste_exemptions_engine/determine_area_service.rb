# frozen_string_literal: true

module WasteExemptionsEngine
  class DetermineAreaService < BaseService
    def run(easting:, northing:)
      return unless valid_arguments?(easting, northing)

      lookup_area(easting, northing)
    end

    private

    def valid_arguments?(easting, northing)
      return false unless valid_argument?(easting)
      return false unless valid_argument?(northing)

      true
    end

    def valid_argument?(argument)
      return false unless argument.is_a?(Numeric)
      return false unless argument.positive?

      true
    end

    def lookup_area(easting, northing)
      response = DefraRuby::Area::PublicFaceAreaService.run(easting, @orthing)

      return response.areas.first.long_name if response.successful?
      return "Outside England" if response.error.instance_of?(DefraRuby::Area::NoMatchError)

      handle_error(response.error, easting, northing)
      nil
    end

    def handle_error(error, easting, northing)
      Airbrake.notify(error, easting: easting, northing: northing) if defined? Airbrake
      Rails.logger.error "Area lookup failed:\n #{error}"
    end

  end
end
