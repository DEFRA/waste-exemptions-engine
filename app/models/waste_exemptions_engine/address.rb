# frozen_string_literal: true

module WasteExemptionsEngine
  class Address < ApplicationRecord
    include CanBeLocatedByGridReference

    self.table_name = "addresses"

    belongs_to :registration
    has_many :registration_exemptions, dependent: :destroy

    enum :address_type, { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum :mode, { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    scope :missing_easting_or_northing, -> { where("x IS NULL OR y IS NULL") }
    scope :with_postcode, -> { where.not(postcode: [nil, ""]) }
    scope :with_valid_easting_and_northing, -> { where.not(x: [nil, 0.00]).where.not(y: [nil, 0.00]) }
    scope :missing_area, -> { where(area: [nil, ""]) }
  end
end
