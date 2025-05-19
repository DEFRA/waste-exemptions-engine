# frozen_string_literal: true

module WasteExemptionsEngine
  class EaPublicFaceArea < ApplicationRecord
    self.table_name = "ea_public_face_areas"
    validates :name, presence: true
    validates :code, presence: true

    OUTSIDE_ENGLAND_CODE = "OUTSIDE_ENGLAND"

    scope :containing_point, lambda { |easting, northing|
      point = RGeo::Cartesian.factory.point(easting, northing)
      where(arel_table[:area].st_contains(point))
    }

    def self.find_by_coordinates(longitude, latitude)
      containing_point(longitude, latitude).first
    end

    def self.outside_england_area
      find_or_create_by(code: OUTSIDE_ENGLAND_CODE) do |area|
        area.name = "Outside England"
        area.area_id = "OUTSIDE_ENGLAND"
      end
    end
  end
end
