# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < BaseForm
    attr_accessor :address_finder_error
    attr_accessor :operator_address
    attr_accessor :premises, :street_address, :locality, :postcode, :city, :business_type

    delegate :business_type, to: :transient_registration

    validates :operator_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      permitted_attributes = params.require(:operator_address)
      permitted_attributes = permitted_attributes.permit(:locality, :postcode, :city, :premises, :street_address, :mode)

      # Needed for validation
      assign_params(permitted_attributes)

      super(operator_address_attributes: permitted_attributes)
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_operator_postcode

      self.operator_address = transient_registration.operator_address

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = transient_registration.address_finder_error
      transient_registration.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      prefill_operator_address_params if saved_address_still_valid?
    end

    def assign_params(permitted_attributes)
      self.operator_address = transient_registration.build_operator_address(permitted_attributes)

      prefill_operator_address_params
    end

    def saved_address_still_valid?
      return false unless operator_address
      return true if postcode.blank?
      return true if postcode == operator_address.postcode

      false
    end

    def prefill_operator_address_params
      return unless operator_address

      self.premises = operator_address.premises&.strip
      self.street_address = operator_address.street_address&.strip
      self.locality = operator_address.locality&.strip
      self.city = operator_address.city&.strip
      self.postcode = operator_address.postcode&.strip
    end
  end
end
