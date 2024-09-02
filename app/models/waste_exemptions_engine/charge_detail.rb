# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargeDetail < ApplicationRecord
    self.table_name = "charge_details"

    has_many :band_charge_details, dependent: :destroy
    belongs_to :order

    before_save :recalculate_total_charge_amount

    def total_compliance_charge_amount
      band_charge_details.sum(&:total_compliance_charge_amount) + (bucket_charge_amount || 0)
    end

    def recalculate_total_charge_amount
      self.total_charge_amount = registration_charge_amount + total_compliance_charge_amount
    end

    def total_charge_amount
      read_attribute(:total_charge_amount) || recalculate_total_charge_amount
    end
  end
end
