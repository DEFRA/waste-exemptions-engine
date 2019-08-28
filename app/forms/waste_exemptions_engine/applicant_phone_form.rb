# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneForm < BaseForm
    attr_accessor :phone_number

    validates :phone_number, "defra_ruby/validators/phone_number": true

    def initialize(registration)
      super
      self.phone_number = @transient_registration.applicant_phone
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.phone_number = params[:phone_number]
      attributes = { applicant_phone: phone_number }

      super(attributes)
    end
  end
end
