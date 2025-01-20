# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmerChargingStrategy < ChargingStrategy
    attr_reader :bucket

    def initialize(order)
      @bucket = order.bucket

      super
    end

    # If the only selected exemptions are in the farmer bucket and the total compliance
    # charge (if non-farmer-bucket) would have been less than the standard registration
    # charge, registration_charge_amount should return the lower value.
    def registration_charge_amount
      default_registration_charge_amount = super

      # Any non-bucket exemptions in the order?
      return default_registration_charge_amount unless (order.exemptions - bucket.exemptions).empty?

      non_bucket_compliance_charge = order.exemptions.sum { |ex| ex.band.initial_compliance_charge.charge_amount }

      [non_bucket_compliance_charge, default_registration_charge_amount].min
    end

    def charge_detail
      unless order.charge_detail.present?
        order.charge_detail = ChargeDetail.new(
          registration_charge_amount:,
          band_charge_details:,
          bucket_charge_amount:
        )
      end
      order.charge_detail
    end

    private

    def bucket_charge_amount
      order.exemptions.intersect?(bucket.exemptions) ? bucket.initial_compliance_charge.charge_amount : 0
    end

    def chargeable_exemptions(band)
      order.exemptions
           .select { |ex| ex.band == band }
           .reject { |ex| bucket.exemptions.include?(ex) }
    end
  end
end
