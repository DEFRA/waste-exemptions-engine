# frozen_string_literal: true

module WasteExemptionsEngine
  class Address < ActiveRecord::Base
    belongs_to :enrollment

    self.table_name = "addresses"

    enum address_type: { unknown: 0, operator: 1 }

    def self.create_from_address_finder_data(data)
      data = data.except("address").except("state_date")
      data["uprn"] = data["uprn"].to_s
      data["x"] = data["x"].to_f
      data["y"] = data["y"].to_f

      Address.create(data)
    end
  end
end
