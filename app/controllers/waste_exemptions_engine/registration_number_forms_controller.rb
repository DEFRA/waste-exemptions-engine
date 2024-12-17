# frozen_string_literal: true

module WasteExemptionsEngine
  class RegistrationNumberFormsController < FormsController
    def new
      super(RegistrationNumberForm, "registration_number_form")
    end

    def create
      super(RegistrationNumberForm, "registration_number_form")
    rescue StandardError => e
      Rails.logger.error "Failed to load companies house details: #{e}"
      render("waste_exemptions_engine/shared/companies_house_down")
    end

    private

    def transient_registration_attributes
      params.fetch(:registration_number_form, {}).permit(:temp_company_no)
    end
  end
end
