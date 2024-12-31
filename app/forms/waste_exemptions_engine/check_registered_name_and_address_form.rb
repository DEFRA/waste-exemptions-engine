# frozen_string_literal: true

require "defra_ruby/companies_house"

module WasteExemptionsEngine
  class CheckRegisteredNameAndAddressForm < BaseForm
    delegate :temp_use_registered_company_details, to: :transient_registration
    delegate :temp_company_no, :company_no, to: :transient_registration
    delegate :registered_company_name, to: :transient_registration
    delegate :operator_name, to: :transient_registration

    validates :temp_use_registered_company_details, "defra_ruby/validators/true_false": true

    def registered_company_name
      companies_house_details[:company_name]
    end

    def registered_office_address_lines
      companies_house_details[:registered_office_address]
    end

    def submit(params)
      if params[:temp_use_registered_company_details] == "true"
        params[:operator_name] = registered_company_name
        params[:company_no] = temp_company_no
      end
      super
    end

    def companies_house_details
      @companies_house_details = DefraRuby::CompaniesHouse::API.run(
        company_number: @transient_registration.temp_company_no
      )
    end
  end
end
