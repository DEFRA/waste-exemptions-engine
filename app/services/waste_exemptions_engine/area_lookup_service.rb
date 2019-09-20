# frozen_string_literal: true

module WasteExemptionsEngine
  class AreaLookupService < BaseService
    def run(easting:, northing:)
      @easting = easting
      @northing = northing

      return unless valid_arguments?

      lookup_area
    end

    private

    def lookup_area
      response = DefraRuby::Area::PublicFaceAreaService.run(@easting, @northing)

      return response.areas.first.long_name if response.successful?
      return "Outside England" if response.error.instance_of?(DefraRuby::Area::NoMatchError)

      nil
    end

    def valid_arguments?
      return false unless @easting.is_a?(Numeric) && @northing.is_a?(Numeric)

      true
    end
  end
end
