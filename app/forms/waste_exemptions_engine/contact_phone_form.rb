# frozen_string_literal: true

module WasteExemptionsEngine
  class ContactPhoneForm < BaseForm
    attr_accessor :phone_number

    set_callback :initialize, :after, :set_phone_number

    def submit(params)
      # Assign the params for validation and pass them to the BaseForm method for updating
      self.phone_number = params[:phone_number]
      attributes = { contact_phone: phone_number }

      super(attributes)
    end

    validates :phone_number, "waste_exemptions_engine/phone_number": true

    private

    def set_phone_number
      self.phone_number = @transient_registration.contact_phone
    end
  end
end
