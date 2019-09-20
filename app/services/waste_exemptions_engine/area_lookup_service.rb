# frozen_string_literal: true

module WasteExemptionsEngine
  class AreaLookupService < BaseService
    def run(easting:, northing:)
      @easting = easting
      @northing = northing

      return unless valid_arguments?

    end

    private

    def valid_arguments?
      return false unless @easting.is_a?(Numeric) && @northing.is_a?(Numeric)

      true
    end
  end
end
