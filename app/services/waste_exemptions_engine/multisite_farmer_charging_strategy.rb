# frozen_string_literal: true

module WasteExemptionsEngine
  class MultisiteFarmerChargingStrategy < FarmerChargingStrategy
    def initial_compliance_charge_amount(band)
      super * site_count
    end

    def additional_compliance_charge_amount(band)
      super * site_count
    end

    def bucket_charge_amount
      super * site_count
    end

    def site_count
      order.order_owner.site_count
    end
  end
end
