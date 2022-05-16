# frozen_string_literal: true

require "defra_ruby_companies_house"

module WasteExemptionsEngine
  class CheckRegisteredNameAndAddressFormsController < FormsController
    def new
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
    end

    def create
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:check_registered_name_and_address_form, {}).permit(:temp_use_registered_company_details)
    end
  end
end
