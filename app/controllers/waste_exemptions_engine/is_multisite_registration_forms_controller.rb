# frozen_string_literal: true

module WasteExemptionsEngine
  class IsMultisiteRegistrationFormsController < FormsController
    def new
      super(IsMultisiteRegistrationForm, "is_multisite_registration_form")
    end

    def create
      nil unless super(IsMultisiteRegistrationForm, "is_multisite_registration_form")
    end

    private

    def transient_registration_attributes
      params.fetch(:is_multisite_registration_form, {}).permit(:is_multisite_registration)
    end
  end
end
