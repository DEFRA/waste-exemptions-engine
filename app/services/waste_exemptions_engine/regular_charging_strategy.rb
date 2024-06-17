# frozen_string_literal: true

module WasteExemptionsEngine
  class RegularChargingStrategy < ChargingStrategy

    private

    def initial_compliance_charge_amount(band)
      band == highest_band ? band.initial_compliance_charge.charge_amount : 0
    end

    def additional_compliance_charge_amount(band, initial_compliance_charge_applied)
      # SonarCloud complains about unused parameters but we need them for inheritance
      # But if we use them to placate SonarCloud, Rubocop complains about void contexts
      # rubocop:disable Lint/Void
      initial_compliance_charge_applied
      # rubocop:enable Lint/Void

      band_exemptions_count = order.exemptions.select { |ex| ex.band == band }.count
      count = (band == highest_band ? band_exemptions_count - 1 : band_exemptions_count)
      count * band.additional_compliance_charge.charge_amount
    end
  end
end
