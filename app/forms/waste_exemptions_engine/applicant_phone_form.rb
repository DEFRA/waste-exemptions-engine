# frozen_string_literal: true

module WasteExemptionsEngine
  class ApplicantPhoneForm < BaseForm

    attr_accessor :phone_number

    def initialize(registration)
      super
      self.phone_number = @transient_registration.applicant_phone
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.phone_number = params[:phone_number]
      attributes = { applicant_phone: phone_number }

      super(attributes, params[:token])
    end

    validates :phone_number, "waste_exemptions_engine/phone_number": true
  end
end
