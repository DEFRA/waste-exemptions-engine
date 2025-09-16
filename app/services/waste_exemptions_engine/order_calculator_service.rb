# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderCalculatorService
    attr_reader :order, :strategy, :calculator

    delegate :band_charge_details,
             :bucket_charge_amount,
             :charge_detail,
             :registration_charge_amount,
             :total_charge_amount,
             :total_compliance_charge_amount,
             to: :calculator

    def initialize(order)
      @order = order
      @calculator = OrderCalculator.new(order:, strategy_type:)
    end

    def strategy_type
      @strategy_type ||= determine_strategy_type
    end

    private

    def determine_strategy_type
      return MultisiteFarmerChargingStrategy if multisite_farmer_registration?
      return MultisiteChargingStrategy if multisite_registration?
      return FarmerChargingStrategy if farmer_registration?

      RegularChargingStrategy
    end

    def multisite_farmer_registration?
      new_charged_registration? && multisite_registration? && farmer_bucket?
    end

    def multisite_registration?
      new_charged_registration? && order.order_owner.is_multisite_registration
    end

    def farmer_registration?
      farmer_bucket?
    end

    def new_charged_registration?
      order.order_owner.is_a?(NewChargedRegistration)
    end

    def farmer_bucket?
      order.bucket&.farmer?
    end
  end
end
