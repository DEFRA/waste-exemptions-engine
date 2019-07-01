# frozen_string_literal: true

module WasteExemptionsEngine
  class Address < ActiveRecord::Base
    include CanBeLocatedByGridReference

    self.table_name = "addresses"

    belongs_to :registration

    enum address_type: { unknown: 0, operator: 1, contact: 2, site: 3 }
    enum mode: { unknown_mode: 0, lookup: 1, manual: 2, auto: 3 }
  end
end
