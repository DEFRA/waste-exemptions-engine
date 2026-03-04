# frozen_string_literal: true

module WasteExemptionsEngine
  module ActivityExemptionsFormsHelper
    def selected_activity_exemptions(transient_registration)
      WasteExemptionsEngine::Exemption.for_waste_activities(transient_registration.temp_waste_activities)
    end

    def exemption_charge_display(exemption)
      band = exemption.band
      return "£0" unless band&.charged?

      initial = format_pence_as_pounds(band.initial_compliance_charge.charge_amount)
      return "£#{initial}" unless band.discount_possible?

      additional = format_pence_as_pounds(band.additional_compliance_charge.charge_amount)
      "£#{initial} (£#{additional})"
    end

    def farming_exemption?(exemption)
      farming_exemption_ids.include?(exemption.id.to_s)
    end

    def farming_exemption_ids
      @farming_exemption_ids ||= begin
        farmer_bucket = WasteExemptionsEngine::Bucket.farmer_bucket
        farmer_bucket ? farmer_bucket.exemption_ids : []
      end
    end

    private

    def format_pence_as_pounds(pence)
      WasteExemptionsEngine::CurrencyConversionService.convert_pence_to_pounds(pence, hide_pence_if_zero: true)
    end
  end
end
