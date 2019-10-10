# frozen_string_literal: true

module WasteExemptionsEngine
  # Used to perform a basic check on easting and northing (x & y) values
  module CanCheckEastingAndNorthingValues
    extend ActiveSupport::Concern

    private

    def valid_coordinates?(easting, northing)
      valid_coordinate?(easting) && valid_coordinate?(northing)
    end

    def valid_coordinate?(coordinate)
      coordinate.is_a?(Numeric) && coordinate.positive?
    end
  end
end
