# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < PostcodeForm
    attr_accessor :business_type

    set_callback :initialize, :after, :set_business_type

    private

    def existing_postcode
      @transient_registration.temp_operator_postcode
    end

    def set_business_type
      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
    end
  end
end
