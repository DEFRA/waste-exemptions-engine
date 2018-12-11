# frozen_string_literal: true

module WasteExemptionsEngine
  class BusinessTypeFormsController < FormsController
    def new
      super(BusinessTypeForm, "business_type_form")
    end

    def create
      super(BusinessTypeForm, "business_type_form")
    end
  end
end
