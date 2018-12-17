# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPhoneForm < BaseForm
    include CanNavigateFlexibly

    attr_accessor :phone_number

    def initialize(enrollment)
      super
      self.phone_number = @enrollment.contact_phone
    end

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.phone_number = params[:phone_number]
      attributes = { contact_phone: phone_number }

      super(attributes, params[:token])
    end

    validates :phone_number, "waste_exemptions_engine/phone_number": true
  end
end
