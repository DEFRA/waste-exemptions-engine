# frozen_string_literal: true

module WasteExemptionsEngine
  class CharityChargingStrategy < ChargingStrategy
    def registration_charge_amount
      0
    end

    def only_no_charge_exemptions?
      true
    end

    def base_bucket_charge_amount
      0
    end

    private

    def initial_compliance_charge_amount(_band)
      0
    end

    def additional_compliance_charge_amount(_band)
      0
    end
  end
end
