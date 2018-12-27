# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < PostcodeForm
    include CanNavigateFlexibly

    attr_accessor :business_type

    def initialize(enrollment)
      super

      # We only use this for the correct microcopy
      self.business_type = @enrollment.business_type
    end

    private

    def existing_postcode
      @enrollment.interim.operator_postcode
    end
  end
end
