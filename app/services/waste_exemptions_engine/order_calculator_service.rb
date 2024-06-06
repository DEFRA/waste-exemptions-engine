# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderCalculatorService

    attr_reader :order, :strategy, :calculator

    delegate :calculate_registration_charge,
             :calculate_compliance_charges,
             :calculate_total_compliance_charge,
             :calculate_total_charge,
             :charge_details,
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
