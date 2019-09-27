# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneForm < BaseForm
    delegate :applicant_phone, to: :transient_registration

    validates :applicant_phone, "defra_ruby/validators/phone_number": true

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      attributes = { applicant_phone: params[:applicant_phone] }

      super(attributes)
    end
  end
end
