# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmerChargingStrategy < ChargingStrategy
    attr_reader :bucket

    def initialize(order)
      @bucket = order.bucket

      super
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
