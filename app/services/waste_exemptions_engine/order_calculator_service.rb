# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderCalculatorService

    attr_reader :order, :strategy, :calculator

    delegate :band_charge_details,
             :charge_detail,
             :registration_charge_amount,
             :total_charge_amount,
             :total_compliance_charge_amount,
             to: :calculator

    def initialize(order)
      @order = order
      @strategy = strategy_type.new(order)
      @calculator = OrderCalculator.new(order: order, strategy: strategy)
    end

    def strategy_type
      @strategy_type ||= if order.bucket? && order.bucket.name == "Farmer exemptions"
                           FarmerChargingStrategy
                         else
                           RegularChargingStrategy
                         end
    end
  end
end
