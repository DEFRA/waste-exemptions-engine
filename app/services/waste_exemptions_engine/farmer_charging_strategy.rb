# frozen_string_literal: true

module WasteExemptionsEngine
  class FarmerChargingStrategy < ChargingStrategy
    attr_reader :bucket

    def initialize(order)
      @bucket = order.bucket

      super
    end

    def charge_details
      ChargeDetail.new(
        registration_charge_amount:,
        band_charge_details:,
        bucket_charge_amount:
      )
    end

    private

    def bucket_charge_amount
      return 0 unless any_qualifying_bucket_exemptions

      bucket.initial_compliance_charge.charge_amount
    end

    def order_exemptions_in_bucket
      order.exemptions.select { |ex| bucket.exemptions.include?(ex) }
    end

    def any_qualifying_bucket_exemptions
      bucket.present? && !order_exemptions_in_bucket.empty?
    end

    def initial_compliance_charge(band)
      return 0 if any_qualifying_bucket_exemptions

      band == highest_band ? band.initial_compliance_charge.charge_amount : 0
    end

    def additional_compliance_charge(band, initial_compliance_charge_applied)
      additional_exemptions_count(band,
                                  initial_compliance_charge_applied) * band.additional_compliance_charge.charge_amount
    end

    def additional_exemptions_count(band, initial_compliance_charge_applied)
      exemptions_already_charged = initial_compliance_charge_applied ? 1 : 0
      order_exemptions_in_band = order.exemptions.select { |ex| ex.band == band }.count
      bucket_exemptions_in_band = order_exemptions_in_bucket.select { |ex| ex.band == band }.count

      order_exemptions_in_band - bucket_exemptions_in_band - exemptions_already_charged
    end
  end
end
