# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargeAdjustment < ApplicationRecord
    self.table_name = "charge_adjustments"

    belongs_to :account
    validates :amount_change, presence: true
    validates :reason, presence: true
    validates :adjustment_type, presence: true

    enum :adjustment_type, {
      increase: "increase",
      decrease: "decrease"
    }
  end
end
