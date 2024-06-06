# frozen_string_literal: true

module WasteExemptionsEngine
  class OrderCalculator

    attr_reader :order, :strategy

    delegate :charge_details, to: :strategy

    def initialize(order:, strategy:)
      @order = order
      @strategy = strategy.new(order)
    end

    def calculate_registration_charge
      @order.exemptions.empty? ? 0 : charge_details.registration_charge_amount
      charge_details.registration_charge_amount
    end

    def calculate_compliance_charges
      charge_details.band_charge_details.to_a
    end

    def calculate_total_compliance_charge
      charge_details.total_compliance_charge_amount
    end

    def calculate_total_charge
      charge_details.total_charge_amount
    end
  end
end
