# frozen_string_literal: true

module WasteExemptionsEngine
  class EaPublicFaceArea < ApplicationRecord
    self.table_name = "ea_public_face_areas"
    validates :name, presence: true
    validates :code, presence: true

    scope :containing_point, ->(easting, northing) {
      point = RGeo::Cartesian.factory.point(easting, northing)
      where(arel_table[:area].st_contains(point))
    }

    def self.find_by_coordinates(longitude, latitude)
      containing_point(longitude, latitude).first
    end
  end
end
