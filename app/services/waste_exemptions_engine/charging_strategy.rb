# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargingStrategy
    attr_reader :order

    delegate :highest_band, to: :order

    def initialize(order)
      @order = order
    end

    def registration_charge_amount
      order.exemptions.empty? ? 0 : Charge.find_by(charge_type: "registration_charge").charge_amount
    end

    def charge_detail
      unless order.charge_detail.present?
        order.charge_detail = ChargeDetail.new(
          registration_charge_amount:,
          band_charge_details:
        )
      end
      order.charge_detail
    end

    def total_compliance_charge_amount
      charge_detail.total_compliance_charge_amount
    end

    def total_charge_amount
      charge_detail.total_charge_amount
    end

    def band_charge_details
      bands = Band.where(id: order.exemptions.map(&:band_id).uniq)
      bands.map do |band|

        initial_compliance_charge_amount = initial_compliance_charge_amount(band)
        additional_compliance_charge_amount = additional_compliance_charge_amount(band)

        BandChargeDetail.new(
          band_id: band.id,
          initial_compliance_charge_amount:,
          additional_compliance_charge_amount:
        )
      end
    end

    private

    # Override this in subclasses to exclude exemptions from charging
    def chargeable_exemptions(band)
      order.exemptions.select { |ex| ex.band == band }
    end

    def initial_compliance_charge_amount(band)
      return 0 if band != highest_band || chargeable_exemptions(band).none?

      band.initial_compliance_charge.charge_amount * site_count
    end

    def additional_compliance_charge_amount(band)
      total_chargeable_count = chargeable_exemptions(band).count
      additional_chargeable_count = total_chargeable_count - (band == highest_band ? 1 : 0)
      return 0 if additional_chargeable_count < 1

      (additional_chargeable_count * band.additional_compliance_charge.charge_amount) * site_count
    end

    def site_count
      order.order_owner&.site_count || 1
    end
  end
end
