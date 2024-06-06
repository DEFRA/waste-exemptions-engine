# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargeDetailBandChargeDetail < ApplicationRecord
    self.table_name = "charge_detail_band_charge_details"

    belongs_to :charge_detail
    belongs_to :band_charge_detail
  end
end
