# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    attr_accessor :business_type

    def initialize(registration)
      super

      # We only use this for the correct microcopy
      self.business_type = @transient_registration.business_type
    end

    private

    def existing_postcode
      @transient_registration.temp_operator_postcode
    end
  end
end
