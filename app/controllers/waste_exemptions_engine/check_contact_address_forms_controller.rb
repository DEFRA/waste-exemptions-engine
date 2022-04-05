# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckContactAddressFormsController < FormsController
    def new
      super(CheckContactAddressForm, "check_contact_address_form")
    end

    def create
      super(CheckContactAddressForm, "check_contact_address_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:check_contact_address_form, {}).permit(:temp_reuse_operator_address)
    end
  end
end
