# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < BasePostcodeForm
    delegate :business_type, to: :transient_registration

    attr_accessor :temp_operator_postcode

    validates :temp_operator_postcode, "waste_exemptions_engine/postcode": true

    def initialize(registration)
      super

      # We only use this for the correct microcopy
      self.temp_operator_postcode = transient_registration.temp_operator_postcode
    end

    def submit(params)
      self.temp_operator_postcode = format_postcode(params[:temp_operator_postcode])

      # We persist the postcode regardless of validations.
      transient_registration.update_attributes(temp_operator_postcode: temp_operator_postcode)

      super({})
    end
  end
end
