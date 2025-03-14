# frozen_string_literal: true

module WasteExemptionsEngine
  class T28ExemptionValidator < BaseValidator
    include CanValidatePresence
    def validate_each(record, attribute, value)
      return true unless value_is_present?(record, attribute, value)
      return true if WasteExemptionsEngine.configuration.host_is_back_office?

      t28_exemption = Exemption.find_by(code: "T28")

      if t28_exemption && value.include?(t28_exemption.id.to_s)
        add_validation_error(record, attribute, :t28_exemption_selected)
        false
      else
        true
      end
    end
  end
end
