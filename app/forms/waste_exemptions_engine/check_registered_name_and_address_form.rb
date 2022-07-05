# frozen_string_literal: true

module WasteExemptionsEngine
  class CheckRegisteredNameAndAddressForm < BaseForm
    delegate :temp_use_registered_company_details, to: :transient_registration
    delegate :company_no, to: :transient_registration
    delegate :registered_company_name, to: :transient_registration
    delegate :operator_name, to: :transient_registration

    validates :temp_use_registered_company_details, "defra_ruby/validators/true_false": true

    def registered_company_name
      companies_house_service.company_name
    end

    def registered_office_address_lines
      companies_house_service.registered_office_address_lines
    end

    def submit(params)
      params[:operator_name] = registered_company_name if params[:temp_use_registered_company_details] == "true"
      super(params)
    end

    private

    def companies_house_service
      @_companies_house_service ||= DefraRubyCompaniesHouse.new(company_no)
    end
  end
end
