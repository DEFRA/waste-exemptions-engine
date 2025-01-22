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
      @strategy_type ||= if order.bucket&.farmer?
                           FarmerChargingStrategy
                         else
                           RegularChargingStrategy
                         end
    end
  end
end
