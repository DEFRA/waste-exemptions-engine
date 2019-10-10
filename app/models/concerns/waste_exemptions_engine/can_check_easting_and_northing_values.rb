# frozen_string_literal: true

module WasteExemptionsEngine
  # Used to perform a basic check on easting and northing (x & y) values
  module CanCheckEastingAndNorthingValues
    extend ActiveSupport::Concern

    private

    def valid_coordinates?(easting, northing)
      return false unless valid_coordinate?(easting)
      return false unless valid_coordinate?(northing)

      true
    end

    def valid_coordinate?(coordinate)
      return false unless coordinate.is_a?(Numeric)
      return false unless coordinate.positive?

      true
    end
  end
end
