# frozen_string_literal: true

module WasteExemptionsEngine
  class OperatorAddressManualForm < BaseForm
    include CanClearAddressFinderError

    delegate :operator_address, :business_type, to: :transient_registration
    delegate :premises, :street_address, :locality, :postcode, :city, to: :operator_address, allow_nil: true

    attr_accessor :postcode

    validates :operator_address, "waste_exemptions_engine/manual_address": true

    after_initialize :setup_postcode

    def submit(params)
      super(operator_address_attributes: params[:operator_address] || {})
    end

    private

    def setup_postcode
      self.postcode = transient_registration.temp_operator_postcode

      # Prefill the existing address unless the postcode has changed from the existing address's postcode
      transient_registration.operator_address = nil unless saved_address_still_valid?
    end

    def saved_address_still_valid?
      postcode == operator_address&.postcode
    end
  end
end
