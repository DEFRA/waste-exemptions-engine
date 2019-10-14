# frozen_string_literal: true

module WasteExemptionsEngine
  class AssignSiteDetailsService < BaseService
    attr_reader :address
    delegate :x, :y, :grid_reference, :postcode, :area, to: :address

    def run(address:)
      @address = address

      assign_x_and_y
      assign_grid_reference
      assign_area_from_x_and_y
    end

    private

    def assign_x_and_y
      return unless x_and_y_are_nil?

      result = DetermineEastingAndNorthingService.run(grid_reference: grid_reference, postcode: postcode)
      address.x = result[:easting]
      address.y = result[:northing]
    end

    def assign_grid_reference
      return if grid_reference.present?
      return unless valid_coordinates?

      address.grid_reference = DetermineGridReferenceService.run(easting: x, northing: y)
    end

    def assign_area_from_x_and_y
      return if area.present?
      return unless valid_coordinates?

      address.area = DetermineAreaService.run(easting: x, northing: y)
    end

    def x_and_y_are_nil?
      x.nil? || y.nil?
    end

    def valid_coordinates?
      valid_coordinate?(x) && valid_coordinate?(y)
    end

    def valid_coordinate?(coordinate)
      coordinate.is_a?(Numeric) && coordinate.positive?
    end
  end
end
