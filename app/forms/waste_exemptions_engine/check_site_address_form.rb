# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckSiteAddressForm < BaseForm
    delegate :operator_address, to: :transient_registration
    delegate :contact_address, to: :transient_registration
    delegate :temp_reuse_operator_address, to: :transient_registration
    delegate :temp_reuse_address_for_site_location, to: :transient_registration

    validates :temp_reuse_address_for_site_location, "waste_exemptions_engine/reusing_address_for_site_address": true

    def submit(params)
      if params[:temp_reuse_address_for_site_location] == "operator_address_option"
        params[:site_address] = TransientAddress.new(
          operator_address.attributes
            .except("id", "created_at", "updated_at", "address_type")
            .merge(address_type: "site")
        )
      end

      if params[:temp_reuse_address_for_site_location] == "contact_address_option"
        params[:site_address] = TransientAddress.new(
          contact_address.attributes
            .except("id", "created_at", "updated_at", "address_type")
            .merge(address_type: "site")
        )
      end

      super(params)
    end
  end
end
