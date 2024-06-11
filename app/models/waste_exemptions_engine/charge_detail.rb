# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargeDetail < ApplicationRecord
    self.table_name = "charge_details"

    has_many :band_charge_details, dependent: :destroy

    def total_compliance_charge_amount
      non_bucket_compliance_charge_amount = band_charge_details.sum do |bc|
        bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount
      end

      non_bucket_compliance_charge_amount + bucket_charge_amount
    end

    def total_charge_amount
      registration_charge_amount +
        total_compliance_charge_amount
    end
  end
end
