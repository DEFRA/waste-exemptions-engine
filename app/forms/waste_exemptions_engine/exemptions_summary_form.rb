# frozen_string_literal: true

module WasteExemptionsEngine
  class ExemptionsSummaryForm < BaseForm
    delegate :exemptions,
             :compliance_charge,
             :single_site_compliance_charge,
             :registration_charge,
             :total_charge,
             :farm_exemptions_selected?,
             :farming_exemptions,
             :non_farming_exemptions,
             :farming_exemptions_codes,
             :farming_exemptions_charge,
             :farming_exemptions_single_site_charge,
             :exemption_title_with_band,
             to: :exemption_costs_presenter

    delegate :farm_affiliated?, :site_count, to: :transient_registration

    def order
      @order ||= create_or_update_order
    end

    def exemption_costs_presenter
      @exemption_costs_presenter ||= WasteExemptionsEngine::ExemptionCostsPresenter.new(order:)
    end

    private

    def create_or_update_order
      WasteExemptionsEngine::CreateOrUpdateOrderService.run(transient_registration: @transient_registration)
    end
  end
end
