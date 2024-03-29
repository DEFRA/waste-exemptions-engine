# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < BasePostcodeForm
    delegate :business_type, :temp_operator_postcode, to: :transient_registration

    validates :temp_operator_postcode, "defra_ruby/validators/postcode": true
    validates :temp_operator_postcode, "waste_exemptions_engine/address_lookup": true

    def submit(params)
      params[:temp_operator_postcode] = format_postcode(params[:temp_operator_postcode])

      # We persist the postcode regardless of validations.
      transient_registration.update(params)

      super({})
    end
  end
end
