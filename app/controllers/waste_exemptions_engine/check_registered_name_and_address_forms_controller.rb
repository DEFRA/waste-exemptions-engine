# frozen_string_literal: true

require "defra_ruby_companies_house"

module WasteExemptionsEngine
  class CheckRegisteredNameAndAddressFormsController < FormsController
    def new
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
      return if new_registration

      begin
        render(:invalid_or_inactive_company) unless validate_company_number && validate_company_status
      rescue StandardError
        Rails.logger.error "Failed to load"
        render(:companies_house_down)
      end
    end

    def create
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
    end

    private

    VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX =
      /\A(\d{8,8}$)|([a-zA-Z]{2}\d{6}$)|([a-zA-Z]{2}\d{5}[a-zA-Z]{1}$)\z/i

    def new_registration
      @transient_registration.is_a?(WasteExemptionsEngine::NewRegistration)
    end

    def validate_company_status
      DefraRubyCompaniesHouse.new(@transient_registration.temp_company_no).status == :active
    end

    def validate_company_number
      @transient_registration.temp_company_no&.match?(VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX)
    end

    def transient_registration_attributes
      params.fetch(:check_registered_name_and_address_form, {}).permit(:temp_use_registered_company_details)
    end
  end
end
