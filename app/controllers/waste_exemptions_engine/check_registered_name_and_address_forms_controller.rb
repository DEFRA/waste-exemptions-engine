# frozen_string_literal: true

require "defra_ruby/companies_house"

module WasteExemptionsEngine
  class CheckRegisteredNameAndAddressFormsController < FormsController

    VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX =
      /\A(\d{8,8}$)|([a-zA-Z]{2}\d{6}$)|([a-zA-Z]{2}\d{5}[a-zA-Z]{1}$)\z/i

    def new
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
      # do not perform any rendering or redirects if transient registration is being redirected to start page RUBY-3915
      return if !@transient_registration.persisted? || @transient_registration.workflow_state == "start_form"

      render(:invalid_or_inactive_company) unless validate_company_number && validate_company_status
    rescue StandardError => e
      Rails.logger.error "Failed to load: #{e}"
      render("waste_exemptions_engine/shared/companies_house_down")
    end

    def create
      super(CheckRegisteredNameAndAddressForm, "check_registered_name_and_address_form")
    end

    private

    def validate_company_status
      %i[active voluntary-arrangement].include?(companies_house_details[:company_status])
    end

    def validate_company_number
      @transient_registration.temp_company_no&.match?(VALID_COMPANIES_HOUSE_REGISTRATION_NUMBER_REGEX)
    end

    def companies_house_details
      @companies_house_details ||= @check_registered_name_and_address_form.companies_house_details
    end

    def transient_registration_attributes
      params.fetch(:check_registered_name_and_address_form, {}).permit(:temp_use_registered_company_details)
    end
  end
end
