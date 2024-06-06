# frozen_string_literal: true

module WasteExemptionsEngine
  class ChargingStrategy
    attr_reader :order, :highest_band

    def initialize(order)
      @order = order
      @highest_band = order.highest_band
    end

    def registration_charge_amount
      order.exemptions.empty? ? 0 : Charge.find_by(charge_type: "registration_charge").charge_amount
    end

    def charge_details
      @charge_details = ChargeDetail.new(
        registration_charge_amount:,
        band_charge_details:
      )
    end

    def total_compliance_charge_amount
      @total_compliance_charge_amount ||=
        (order.bucket&.initial_compliance_charge&.charge_amount || 0) +
        band_charge_details.sum do |bc|
          bc.initial_compliance_charge_amount + bc.additional_compliance_charge_amount
        end
    end

    def total_charge_amount
      @total_charge_amount ||= registration_charge_amount + total_compliance_charge_amount
    end

    def band_charge_details
      @band_charge_details ||= populate_band_charge_details
    end

    private

    def populate_band_charge_details
      bands = Band.where(id: order.exemptions.map(&:band_id).uniq)
      bands.map do |band|
        initial_compliance_charge_amount = initial_compliance_charge(band)
        additional_compliance_charge_amount = additional_compliance_charge(
          band,
          initial_compliance_charge_amount.positive?
        )
        BandChargeDetail.new(
          band_id: band.id,
          initial_compliance_charge_amount:,
          additional_compliance_charge_amount:
        )
      end
    end

    # SonarCloud complains about unused parameters on virtual methods
    # :nocov:
    def initial_compliance_charge(_band)
      raise NotImplementedError
    end

    def additional_compliance_charge(_band, _initial_compliance_charge_applied)
      raise NotImplementedError
    end
    # :nocov:
  end
end
