# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < BaseForm
    delegate :premises, :street_address, :locality, :city, to: :operator_address, allow_nil: true
    delegate :operator_address, :business_type, to: :transient_registration

    attr_accessor :postcode, :address_finder_error

    validates :operator_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      super(operator_address_attributes: params[:operator_address])
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_operator_postcode

      # Check if the user reached this page through an Address finder error.
      # Then wipe the temp attribute as we only need it for routing
      self.address_finder_error = transient_registration.address_finder_error
      transient_registration.update_attributes(address_finder_error: nil)

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      transient_registration.operator_address = nil unless saved_address_still_valid?
    end

    def saved_address_still_valid?
      return false unless operator_address

      postcode == operator_address.postcode
    end
  end
end
