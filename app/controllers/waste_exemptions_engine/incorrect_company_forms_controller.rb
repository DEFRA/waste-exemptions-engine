# frozen_string_literal: true

module WasteExemptionsEngine
  class IncorrectCompanyFormsController < FormsController
    def new
      super(IncorrectCompanyForm, "incorrect_company_form")
    end

    def create
      super(IncorrectCompanyForm, "incorrect_company_form")
    end
  end
end
