# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsSummaryForm < BaseForm
    delegate :exemptions, to: :transient_registration

    def order
      @order ||= transient_registration.order || create_order
    end

    def order_calculator
      @order_calculator ||= WasteExemptionsEngine::OrderCalculatorService.new(order)
    end

    private

    def create_order
      WasteExemptionsEngine::OrderCreationService.run(transient_registration: @transient_registration)
    end
  end
end
