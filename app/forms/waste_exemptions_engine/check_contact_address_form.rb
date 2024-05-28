# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactAddressForm < BaseForm
    delegate :operator_address, :contact_address, to: :transient_registration
    delegate :temp_reuse_operator_address, to: :transient_registration

    validates :temp_reuse_operator_address, "defra_ruby/validators/true_false": true

    def submit(params)
      if params[:temp_reuse_operator_address] == "true"
        params[:contact_address] = TransientAddress.new(
          operator_address.attributes
            .except("id", "created_at", "updated_at", "address_type")
            .merge(address_type: "contact")
        )
        params = params.merge(temp_contact_postcode: operator_address.postcode)
      end


      super(params)
    end
  end
end
