# frozen_string_literal: true

module WasteExemptionsEngine
  class BandChargeDetail < ApplicationRecord
    self.table_name = "band_charge_details"

    belongs_to :band
    belongs_to :charge_detail

    def total_compliance_charge_amount
      initial_compliance_charge_amount + additional_compliance_charge_amount
    end
  end
end
