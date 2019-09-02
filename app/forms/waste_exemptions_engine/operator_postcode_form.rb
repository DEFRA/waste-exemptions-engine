# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < BaseForm
    attr_accessor :business_type, :temp_operator_postcode

    validates :temp_operator_postcode, "waste_exemptions_engine/postcode": true

    def initialize(registration)
      super

      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
      self.temp_operator_postcode = @transient_registration.temp_operator_postcode
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method
      # for updating
      self.temp_operator_postcode = format_postcode(params[:temp_operator_postcode])

      # We pass through an empty hash for the attributes, as there is nothing to
      # update on the registration itself
      super({ temp_operator_postcode: temp_operator_postcode })
    end

    # TODO: Move in AddressHelper?
    def format_postcode(postcode)
      postcode.upcase.strip
    end
  end
end
