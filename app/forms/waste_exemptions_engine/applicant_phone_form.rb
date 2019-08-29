# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneForm < BaseForm
    attr_accessor :applicant_phone

    validates :applicant_phone, "defra_ruby/validators/phone_number": true

    def initialize(registration)
      super
      self.applicant_phone = @transient_registration.applicant_phone
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.applicant_phone = params[:applicant_phone]
      attributes = { applicant_phone: applicant_phone }

      super(attributes)
    end
  end
end
