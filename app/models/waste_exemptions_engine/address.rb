# frozen_string_literal: true

module WasteExemptionsEngine
  class Address < ActiveRecord::Base
    include CanBeLocatedByGridReference

    self.table_name = "addresses"

    belongs_to :registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    scope :with_easting_and_northing, -> { where.not(x: nil, y: nil) }
    scope :missing_ea_area, -> { where(area: [nil, ""]) }
  end
end
