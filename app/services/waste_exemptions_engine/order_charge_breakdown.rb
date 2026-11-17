# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderChargeBreakdown
    include CanSortExemptions

    ExemptionCharge = Struct.new(:exemption, :amount_pence, keyword_init: true)

    attr_reader :order

    def initialize(order:)
      @order = order
    end

    def exemption_charges
      @exemption_charges ||= non_bucket_exemptions.group_by(&:band_id).flat_map do |band_id, exemptions|
        allocate_band_charges(band_id, exemptions)
      end
    end

    def bucket_exemptions
      @bucket_exemptions ||= begin
        exemptions = order.bucket ? order.exemptions & order.bucket.exemptions : []
        sorted_exemptions(exemptions)
      end
    end

    def non_bucket_exemptions
      @non_bucket_exemptions ||= sorted_exemptions(order.exemptions - bucket_exemptions)
    end

    def chargeable_exemptions
      non_bucket_exemptions.reject { |exemption| no_charge_band_ids.include?(exemption.band_id) }
    end

    def no_charge_exemptions
      non_bucket_exemptions.select { |exemption| no_charge_band_ids.include?(exemption.band_id) }
    end

    def bucket_charge_amount
      charge_detail&.bucket_charge_amount
    end

    def registration_charge_amount
      charge_detail&.registration_charge_amount
    end

    def total_compliance_charge_amount_excluding_bucket
      charge_detail&.total_compliance_charge_amount_excluding_bucket
    end

    def total_charge_amount
      charge_detail&.total_charge_amount
    end

    private

    def charge_detail
      order.charge_detail
    end

    def no_charge_band_ids
      return [] unless charge_detail

      @no_charge_band_ids ||= charge_detail.band_charge_details.filter_map do |band_detail|
        band_detail.band_id if band_detail.total_compliance_charge_amount.zero?
      end
    end

    def allocate_band_charges(band_id, exemptions)
      detail = band_charge_detail(band_id)
      initial_amount = detail&.initial_compliance_charge_amount.to_i
      additional_amount = additional_charge_per_exemption(detail, exemptions.count, initial_amount)

      exemptions.map.with_index do |exemption, index|
        amount = index.zero? && initial_amount.positive? ? initial_amount : additional_amount
        ExemptionCharge.new(exemption:, amount_pence: amount)
      end
    end

    def band_charge_detail(band_id)
      charge_detail&.band_charge_details&.find { |band_detail| band_detail.band_id == band_id }
    end

    def additional_charge_per_exemption(detail, exemption_count, initial_amount)
      additional_count = exemption_count
      additional_count -= 1 if initial_amount.positive?

      detail&.additional_compliance_charge_amount.to_i / [additional_count, 1].max
    end
  end
end
