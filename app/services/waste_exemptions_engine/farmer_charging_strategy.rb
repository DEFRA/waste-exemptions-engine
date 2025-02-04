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

    def bucket_charge_amount
      order_bucket_exemptions = order.exemptions & bucket.exemptions

      return 0 if order_bucket_exemptions.empty?

      default_bucket_charge_amount = bucket.initial_compliance_charge.charge_amount

      order_bucket_compliance_charge = order_bucket_exemptions.sum { |ex| ex.band.initial_compliance_charge.charge_amount }

      [order_bucket_compliance_charge, default_bucket_charge_amount].min
    end

    private

    def chargeable_exemptions(band)
      order.exemptions
           .select { |ex| ex.band == band }
           .reject { |ex| bucket.exemptions.include?(ex) }
    end
  end
end
