# frozen_string_literal: true

require "defra_ruby_companies_house"

module WasteExemptionsEngine
  class CheckRegisteredNameAndAddressFormsController < FormsController
    def new
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
      begin
        return render(:inactive_company) unless validate_company_status
      rescue StandardError
        Rails.logger.error "Failed to load"
        render(:companies_house_down)
      end
    end

    def create
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
    end

    private

    def validate_company_status
      DefraRubyCompaniesHouse.new(@transient_registration.company_no).status == :active
    end

    def transient_registration_attributes
      params.fetch(:check_registered_name_and_address_form, {}).permit(:temp_use_registered_company_details)
    end
  end
end
