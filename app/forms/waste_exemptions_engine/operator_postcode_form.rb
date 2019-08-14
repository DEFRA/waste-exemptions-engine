# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorPostcodeForm < PostcodeForm
    include CanSetBusinessType

    private

    def existing_postcode
      @transient_registration.temp_operator_postcode
    end
  end
end
