# frozen_string_literal: true

module WasteExemptionsEngine
  class IncorrectCompaniesHouseDetailsFormsController < FormsController
    def new
      super(IncorrectCompaniesHouseDetailsForm, "incorrect_companies_house_details_form")
    end

    def create
      super(IncorrectCompaniesHouseDetailsForm, "incorrect_companies_house_details_form")
    end
  end
end
