# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneForm < BaseForm
    attr_accessor :phone_number

    set_callback :initialize, :after, :set_applicant_phone

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.phone_number = params[:phone_number]
      attributes = { applicant_phone: phone_number }

      super(attributes)
    end

    validates :phone_number, "waste_exemptions_engine/phone_number": true

    private

    def set_applicant_phone
      self.phone_number = @transient_registration.applicant_phone
    end
  end
end
