# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < AddressManualForm
    include CanNavigateFlexibly

    attr_accessor :business_type

    def initialize(enrollment)
      super
      # We only use this for the correct microcopy
      self.business_type = @enrollment.business_type

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = @enrollment.interim.address_finder_error
      @enrollment.interim.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the temp_postcode has changed from the existing address's postcode
      # Otherwise, just fill in the temp_postcode
      saved_address_still_valid? ? prefill_existing_address : self.postcode = existing_postcode
    end

    private

    def existing_postcode
      @enrollment.interim.operator_postcode
    end

    def existing_address
      @enrollment.operator_address
    end

    def address_type
      Address.address_types[:operator]
    end
  end
end
