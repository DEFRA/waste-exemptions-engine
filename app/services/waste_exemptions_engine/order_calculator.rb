# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderCalculator

    attr_reader :order, :strategy

    delegate :band_charge_details,
             :charge_detail,
             :registration_charge_amount,
             :total_charge_amount,
             :total_compliance_charge_amount,
             to: :strategy

    def initialize(order:, strategy_type:)
      @order = order
      @strategy = strategy_type.new(order)
    end
  end
end
