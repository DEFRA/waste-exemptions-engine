# frozen_string_literal: true

module WasteExemptionsEngine
  class Address < ActiveRecord::Base
    include CanBeLocatedByGridReference

    self.table_name = "addresses"

    belongs_to :registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }

    scope :sites_missing_easting_or_northing, -> { where("address_type = 3 AND (x IS NULL OR y IS NULL)") }
    scope :sites_with_easting_and_northing, -> { where("address_type = 3 AND x IS NOT NULL AND y IS NOT NULL") }
    scope :sites_missing_area, -> { where("address_type = 3 AND (area = '' OR area IS NULL)") }
  end
end
